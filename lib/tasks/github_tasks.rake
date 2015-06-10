require 'rake'

namespace :github do
  desc 'Sync issues and tasks from GitHub.'
  task :sync_all => :environment do
    Rails.logger = Logger.new(STDOUT)

    Rake::Task["github:sync_tasks"].invoke
    Rake::Task["github:sync_commits"].invoke
  end

  # For each project linked to GitHub, performs a sync (two-way merge) of any
  # tasks/issues.
  desc 'Sync tasks (issues) from GitHub.'
  task :sync_tasks => :environment do
    projects = Project.where(Project.arel_table[:gh_repo_url].not_eq(nil))

    Rails.logger.debug "Syncing #{projects.count} GitHub-enabled project(s)."

    client = Octokit::Client.new(:access_token => github_auth_token)
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

        if issue[:user]
          creator = Developer.find_by_loginid(issue[:user][:login])

          if creator.nil?
            #Rails.logger.debug "GH issue has developer but could not find developer locally (login ID: #{issue[:assignee][:login]}). Creating ..."
            creator = Developer.new

            creator.loginid = issue[:user][:login]
            creator.email = "unknown@unknown.com"
            creator.name = "Somebody from GitHub"

            creator.save!
          end

          task.creator = creator
        end

        if issue[:assignee]
          assignee = Developer.find_by_loginid(issue[:assignee][:login])

          if assignee.nil?
            #Rails.logger.debug "GH issue has developer but could not find developer locally (login ID: #{issue[:assignee][:login]}). Creating ..."
            assignee = Developer.new

            assignee.loginid = issue[:assignee][:login]
            assignee.email = "unknown@unknown.com"
            assignee.name = "Somebody from GitHub"

            assignee.save!
          end

          if task.new_record?
            assignment = Assignment.new
            assignment.task = task
          else
            assignment = task.assignment
          end
          
          assignment.developer = assignee

          #task.assignee = assignee
        end

        task.created_at = issue[:created_at]

        task.save!
      end

      # # Sync any remaining issues back _to_ GitHub
      # unsynced_tasks = project.tasks.where(Task.arel_table[:gh_issue_number].eq(nil))
      # unsynced_tasks.each do |task|
      #   issue = client.create_issue(project.gh_repo_url, task.title, task.details)
      #
      #   Rails.logger.debug "Exporting task ('#{task.title}') to GitHub."
      #
      #   task.gh_issue_number = issue[:number]
      #   task.save!
      # end
    end
  end

  # Loop through GitHub-linked projects and sync the commit history
  desc 'Sync commits from GitHub.'
  task :sync_commits => :environment do
    projects = Project.where(Project.arel_table[:gh_repo_url].not_eq(nil))

    Rails.logger.debug "Syncing #{projects.count} GitHub-enabled project(s)."

    Octokit.auto_paginate = true
    client = Octokit::Client.new(:access_token => github_auth_token)
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

          commit.account = find_or_create_developer_account_for_commit(gh_commit)
          commit.message = gh_commit[:commit][:message]

          if gh_commit[:commit][:committer]
            commit.committed_at = gh_commit[:commit][:committer][:date]
          elsif gh_commit[:commit][:author]
            commit.committed_at = gh_commit[:commit][:author][:date]
          end

          commit.save!

          Rails.logger.debug "Importing commit ##{gh_commit[:sha]} ('#{gh_commit[:commit][:message]}') from GitHub."
        end

        # Fill in commit statistics
        if commit.total.nil?
          gh_commit_details = client.commit(project.gh_repo_url, commit.sha)

          commit.total = gh_commit_details[:stats][:total]
          commit.additions = gh_commit_details[:stats][:additions]
          commit.deletions = gh_commit_details[:stats][:deletions]

          commit.save!
        end
      end
    end
  end

  private

  # Returns the private GitHub auth token (assuming config/github.yml is configured)
  def github_auth_token
    unless @gh_token
      begin
        gh_config = YAML::load(File.open(Rails.root.join('config', 'github.yml')))
      rescue Errno::ENOENT
        Rails.logger.error "Unable to load #{Rails.root.join('config', 'github.yml')}, ensure it exists."
        abort
      end
    end

    @gh_token ||= gh_config['TOKEN']
  end

  # Finds or creates a developer account for the given GH commit data ('commit').
  # Note: The GitHub API provides a few hints as to who a commit belongs. Preferred
  # is commit[:commit][:author] (signed by git) followed by commit[:author] (probably
  # signed by GitHub) followed by commit[:commit][:committer] (if it exists).
  # We assume email is safely unique but do not trust 'name' as two individuals could
  # share the same name.
  def find_or_create_developer_account_for_commit(commit)
    if commit[:commit][:author] and commit[:commit][:author][:email]
      dev_account = DeveloperAccount.find_or_create_by email: commit[:commit][:author][:email]
      dev_account.account_type = 'git' if dev_account.new_record?
    elsif commit[:author] and commit[:author][:login]
      dev_account = DeveloperAccount.find_or_create_by loginid: commit[:author][:login]
      dev_account.account_type = 'github' if dev_account.new_record?
    elsif commit[:commit][:committer] and commit[:commit][:committer][:email]
      dev_account = DeveloperAccount.find_or_create_by email: [:commit][:committer][:email]
      dev_account.account_type = 'git' if dev_account.new_record?
    end

    # Attempt to match the account with a developer
    unless dev_account.developer
      dev_account.developer = Developer.find_by_email(dev_account.email) if dev_account.email
      dev_account.developer = Developer.find_by_loginid(dev_account.loginid) unless dev_account.developer or dev_account.loginid.nil?
    end

    dev_account.save! if dev_account.new_record? or dev_account.changed?

    if dev_account.nil?
      STDERR.puts "Could not generate a developer account for GitHub commit #{commit}."
      abort
    end

    return dev_account
  end
end
