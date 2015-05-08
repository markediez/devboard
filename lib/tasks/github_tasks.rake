require 'rake'

namespace :github do
  desc 'Run all regularly scheduled GitHub tasks.'
  task :run => :environment do
    Rails.logger = Logger.new(STDOUT)

    begin
      gh_config = YAML::load(File.open(Rails.root.join('config', 'github.yml')))
    rescue Errno::ENOENT
      Rails.logger.error "Unable to load #{Rails.root.join('config', 'github.yml')}, ensure it exists."
      abort
    end

    @gh_token = gh_config['TOKEN']

    sync_tasks
    sync_commits
  end

  # For each project linked to GitHub, performs a sync (two-way merge) of any
  # tasks/issues.
  def sync_tasks
    projects = Project.where(Project.arel_table[:gh_repo_url].not_eq(nil))

    Rails.logger.debug "Syncing #{projects.count} GitHub-enabled project(s)."

    client = Octokit::Client.new(:access_token => @gh_token)
    client.login

    # Check for updates to local tasks in GitHub
    projects.each do |project|
      Rails.logger.debug "Syncing issues/tasks for project '#{project.name}'."

      issues = client.issues(project.gh_repo_url, :per_page => 100)

      Rails.logger.debug "Found #{issues.count} issues on GitHub."

      # Sync issues from GitHub
      issues.each do |issue|
        # Find or create the GH issue locally (DevBoard calls them 'tasks')
        task = project.tasks.find_by_gh_issue_number(issue[:number])

        unless task
          task = Task.new
          task.gh_issue_number = issue[:number]
          task.project = project
          Rails.logger.debug "Importing issue ##{issue[:number]} ('#{issue[:title]}') from GitHub."
        else
          Rails.logger.debug "Updating existing issue ##{issue[:number]} ('#{issue[:title]}') with GitHub."
        end

        task.title = issue[:title]
        task.details = issue[:body]
        task.completed = issue[:closed_at]

        if issue[:assignee]
          developer = Developer.find_by_loginid(issue[:assignee][:login])

          if developer.nil?
            Rails.logger.debug "GH issue has developer but could not find developer locally (login ID: #{issue[:assignee][:login]}). Creating ..."
            developer = Developer.new

            developer.loginid = issue[:assignee][:login]
            developer.email = "unknown@unknown.com"
            developer.name = "Imported from GitHub"

            developer.save!
          end

          task.developer = developer
        end

        task.created_at = issue[:created_at]

        task.save!
      end

      # Sync any remaining issues back _to_ GitHub
      unsynced_tasks = project.tasks.where(Task.arel_table[:gh_issue_number].eq(nil))
      unsynced_tasks.each do |task|
        issue = client.create_issue(project.gh_repo_url, task.title, task.details)

        Rails.logger.debug "Exporting task ('#{task.title}') to GitHub."

        task.gh_issue_number = issue[:number]
        task.save!
      end
    end
  end

  # Loop through GitHub-linked projects and sync the commit history
  def sync_commits
    projects = Project.where(Project.arel_table[:gh_repo_url].not_eq(nil))

    Rails.logger.debug "Syncing #{projects.count} GitHub-enabled project(s)."

    Octokit.auto_paginate = true
    client = Octokit::Client.new(:access_token => @gh_token)
    client.login

    # Check for updates to local tasks in GitHub
    projects.each do |project|
      Rails.logger.debug "Syncing commits for project '#{project.name}'."

      commits = client.commits(project.gh_repo_url)

      Rails.logger.debug "Found #{commits.count} commits on GitHub."

      commits.each do |gh_commit|
        commit = project.commits.find_by_sha(gh_commit[:sha])

        unless commit
          commit = Commit.new
          commit.sha = gh_commit[:sha]
          commit.project = project

          Rails.logger.debug "Importing commit ##{gh_commit[:sha]} ('#{gh_commit[:commit][:message]}') from GitHub."
        else
          Rails.logger.debug "Updating existing commit ##{gh_commit[:sha]} ('#{gh_commit[:commit][:message]}') with GitHub."
        end

        if gh_commit[:author]
          developer = Developer.find_by_loginid(gh_commit[:author][:login])
          developer = Developer.find_by_name(gh_commit[:author][:name]) unless developer

          if developer.nil?
            Rails.logger.debug "GH commit has developer but could not find developer locally (login ID: #{gh_commit[:author][:login]}). Creating ..."
            developer = Developer.new

            if gh_commit[:author][:login]
              developer.loginid = gh_commit[:author][:login]
              developer.email = (gh_commit[:author][:email] ? gh_commit[:author][:email] : "unknown@unknown.com")
              developer.name = (gh_commit[:author][:name] ? gh_commit[:author][:name] : "Imported from GitHub")
            elsif gh_commit[:author][:name]
              developer.loginid = nil
              developer.email = (gh_commit[:author][:email] ? gh_commit[:author][:email] : "unknown@unknown.com")
              developer.name = gh_commit[:author][:name]
            end

            developer.save!
          end

          commit.developer = developer
        end

        commit.message = gh_commit[:commit][:message]

        if gh_commit[:commit][:committer]
          commit.committed_at = gh_commit[:commit][:committer][:date]
        elsif gh_commit[:commit][:author]
          commit.committed_at = gh_commit[:commit][:author][:date]
        end

        commit.save!
      end
    end
  end
end
