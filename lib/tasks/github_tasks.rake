require 'rake'

namespace :github do
  desc 'Run all regularly scheduled GitHub tasks.'
  task :run => :environment do
    sync_tasks
    sync_commits
  end

  def sync_tasks
    tasks = Task.where(Task.arel_table[:gh_issue_number].not_eq(nil))

    github = Github.new

    # Check for updates to local tasks in GitHub
    tasks.each do |task|
      user, project = task.project.gh_repo_url_parse

      unless user and project
        Rails.logger.warn "Project ##{task.project_id} (#{task.project.name}) has an invalid GitHub repository URL or has no GitHub repository URL but does have a task with a GitHub issue ID."
        next
      end

      begin
        issue = github.issues.get(task.project.gh_repo_url_parse(:user), task.project.gh_repo_url_parse(:project), task.gh_issue_number)
      rescue Github::Error::NotFound => e
        Rails.logger.error "GitHub returned a 404 while searching for task ##{task.id} (#{task.title})."
        next
      end

      unless issue
        Rails.logger.error "Could not find GitHub issue referenced by task ##{task.id} (#{task.title})."
        next
      end

      if issue.state == 'open' && task.completed != nil
        task.completed = nil
        task.save!

        developer = Developer.where(gh_username: issue.user.login).first
        unless developer
          Rails.logger.warn "Task ##{task.id} (#{task.title}) was found in GitHub but GitHub references unknown developer '#{issue.closed_by.login}'. Skipping sync for this task ..."
          next
        end

        ActivityLog.create!({developer_id: developer.id, project_id: task.project_id, task_id: task.id, activity_type: :reopened})
      elsif issue.state == 'closed' && task.completed == nil
        task.completed = issue.closed_at
        task.save!

        developer = Developer.where(gh_username: issue.closed_by.login).first
        unless developer
          Rails.logger.warn "Task ##{task.id} (#{task.title}) was found in GitHub but GitHub references unknown developer '#{issue.closed_by.login}'. Skipping sync for this task ..."
          next
        end

        ActivityLog.create!({developer_id: developer.id, project_id: task.project.id, task_id: task.id, activity_type: :completed, when: issue.closed_at})
      end
    end

    # TODO: Check GitHub for tasks which do not already exist locally

  end

  # Loop through any developers in Devboard who have GitHub credentials and sync their commit history with Devboard's "Activity Log".
  def sync_commits
    github = Github.new

    Rails.logger.tagged "github:sync_commits" do
      # For each developer configured with a GitHub token ...
      Developer.where(Developer.arel_table[:gh_personal_token].not_eq(nil)).each do |developer|
        Rails.logger.tagged developer.loginid do
          # Look at their GitHub repositories ...
          repos = github.repos.list(user: developer.gh_username)
          repos.each do |repo|
            repo_user, repo_project = repo.html_url.split('/').last(2)

            repo_url = repo_user + '/' + repo_project

            # Does this repository match a project known to Devboard?
            project = Project.where(gh_repo_url: repo_url).first
            if project
              Rails.logger.info "Found matching GitHub project: #{project.name}"
              Rails.logger.tagged project.name do
                # Loop through commits from developer
                commits = github.repos.commits.list repo_user, repo_project, :author => repo_user
                Rails.logger.info "Found #{commits.length} commits."
                commits.each do |c|
                  # FIXME: PostgreSQL doesn't like when we used activity_type: :pushed so we resort to array notation. Bug in ActiveRecord enums?
                  ActivityLog.find_or_create_by commit_gh_id: c.sha, developer_id: developer.id, project_id: project.id, activity_type: ActivityLog.activity_types["pushed"], when: c.commit.author.date
                end
              end
            else
              Rails.logger.info "Found a GitHub project but it does not match a local project: #{repo_url}"
            end
          end
        end
      end
    end
  end
end
