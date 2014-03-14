require 'rake'

namespace :github do
  desc 'Run all regularly scheduled GitHub tasks.'
  task :run => :environment do
    sync_tasks
    sync_commits
  end
  
  def sync_tasks  
    tasks = Task.where(Task.arel_table[:gh_issue_number].not_eq(nil))
   
    # Check to ensure tasks exist to sync against
    if tasks 
      tasks.each do |task|
        github = Github.new
        issue = github.issues.get(task.project.gh_repo_url_parse(:user), task.project.gh_repo_url_parse(:project), task.gh_issue_number)
        developer = Developer.where(gh_username: issue.closed_by.login).first
        if issue.state == 'open' && task.completed != nil
          task.completed = nil
          task.save!
          ActivityLog.create!({developer_id: developer.id, project_id: task.project.id, task_id: task.id, activity_type: :reopened})
        end
        if issue.state == 'closed' && task.completed == nil
          task.completed = Time.now
          task.save!
          ActivityLog.create!({developer_id: developer.id, project_id: task.project.id, task_id: task.id, activity_type: :completed})
        end
      end
    end
  end
  
  # Loop through any developers in Devboard who have GitHub credentials and sync their commit history with Devboard's "Activity Log".  
  def sync_commits
    # Loop through developers
    Developer.where(Developer.arel_table[:gh_personal_token].not_eq(nil)).each do |developer|
      github = Github.new
      # Loop through developer's github repos
      repos = github.repos.list(user: developer.gh_username)
      repos.each do |repo|
        repo_html = repo.html_url
        ignore, ignore2, ignore3, repo_user, repo_project = repo_html.split('/')
        repo_url = repo_user + '/' + repo_project
        project = Project.where(gh_repo_url: repo_url)
        # Github repo matches devboard project?
        if project.length > 0
          project_id = project.first.id
          # Loop through commits from developer
          github = Github.new
          commits = github.repos.commits.list repo_user, repo_project, :author => repo_user
          commits.each do |c|
            sha = c.sha
            date = c.commit.author.date
            ActivityLog.find_by_commit_gh_id(sha) || ActivityLog.create(:commit_gh_id => sha, :developer_id => developer.id , :project_id => project_id, activity_type: :commit)
          end        
        end
      end   
    end
  end
end

# ActivityLog model   before_create :set_when is setting time currently, it should instead take the time value from github - will need to refactor
# ActivityLog to stop the before_create
