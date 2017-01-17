require 'rake'

namespace :github do
  desc 'Sync issues and tasks from GitHub.'
  task :sync_all => :environment do
    Rails.logger = Logger.new(STDOUT)

    Rake::Task["github:sync_tasks"].invoke
    Rake::Task["github:sync_commits"].invoke
    Rake::Task["github:sync_milestones"].invoke
  end

  # For each project linked to GitHub, pulls all tasks/issues.
  desc 'Pull tasks (issues) from GitHub.'
  task :sync_tasks => :environment do
    require 'github'

    # List of projects which have repositories
    projects = Project.joins(:repositories)

    Rails.logger.debug "Pulling tasks (issues) for #{projects.count} GitHub-enabled project(s)."

    # Check for updates to local tasks in GitHub
    projects.each do |project|
      project.repositories.each do |repository|
        Rails.logger.debug "Pulling tasks (issues) for project '#{project.name}'."

        issues = GitHubService.find_issues_by_project(repository.url)
        Rails.logger.debug "Found #{issues.count} issues on GitHub for repository #{repository.url}."

        # Import issues (open & closed) from GitHub
        issues.each do |issue|
          sync_issue(issue, project, repository)
        end
      end
    end
  end

  # Loop through GitHub-linked projects and import the commit history
  desc 'Pull commits from GitHub.'
  task :sync_commits => :environment do
    require 'github'

    # List of projects which have repositories
    projects = Project.joins(:repositories)

    Rails.logger.debug "Pulling commits for #{projects.count} GitHub-enabled project(s)."

    # Check for updates to local tasks in GitHub
    projects.each do |project|
      Rails.logger.debug "Pulling commits for project '#{project.name}'."

      project.repositories.each do |repository|
        commits = GitHubService.find_commits_by_project(repository.url)

        Rails.logger.debug "Found #{commits.count} commits on GitHub."

        commits.each do |gh_commit|
          commit = project.commits.find_by_sha(gh_commit[:sha])

          unless commit
            Rails.logger.debug "Importing commit ##{gh_commit[:sha]} ('#{gh_commit[:commit][:message]}') from GitHub."

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
          end

          # Fill in commit statistics
          if commit.total.nil?
            gh_commit_details = GitHubService.find_commit_by_project_and_sha(repository.url, commit.sha)

            commit.total = gh_commit_details[:stats][:total]
            commit.additions = gh_commit_details[:stats][:additions]
            commit.deletions = gh_commit_details[:stats][:deletions]

            commit.save!
          end
        end
      end
    end
  end

  # For each project linked to GitHub, pulls all milestones.
  desc 'Sync milestones from GitHub.'
  task :sync_milestones => :environment do
    require 'github'

    # List of projects which have repositories
    projects = Project.joins(:repositories)

    Rails.logger.debug "Pulling milestones for #{projects.count} GitHub-enabled project(s)."

    # Check for updates to local tasks in GitHub
    projects.each do |project|
      Rails.logger.debug "Pulling milestones for project '#{project.name}'."

      project.repositories.each do |repo|
        milestones = GitHubService.find_milestones_by_project(repo.url)
        Rails.logger.debug "Found #{milestones.count} milestones on GitHub."

        # Pull milestones (open & closed) from GitHub
        milestones.each do |milestone|
          sync_milestone(project, milestone)
        end
      end
    end
  end

  private

  # Syncs a single issue from GitHub to the local database
  def sync_issue(issue, project, repository)
    return if issue.class == Array # avoid an odd 'moved permanently' issue ...

    # Find or create the GH issue locally (DevBoard calls them 'tasks')
    task = project.tasks.find_by_gh_issue_number(issue[:number])

    unless task
      task = Task.new
      task.gh_issue_number = issue[:number]
      task.project = project
      task.repository_id = repository.id
      Rails.logger.debug "Importing issue ##{issue[:number]} ('#{issue[:title]}') from GitHub."
    else
      Rails.logger.debug "Updating existing issue ##{issue[:number]} ('#{issue[:title]}') with GitHub."
    end

    task.title = issue[:title]
    task.details = issue[:body]
    task.completed_at = issue[:closed_at]
    task.created_at = issue[:created_at]

    if issue[:user]
      creator = DeveloperAccount.find_by_loginid_and_account_type(issue[:user][:login], 'github')

      if creator.nil?
        creator = DeveloperAccount.new

        creator.loginid = issue[:user][:login]
        creator.account_type = 'github'

        creator.save!
      end

      task.creator = creator
    end

    if issue[:assignee]
      assignee = DeveloperAccount.find_by_loginid_and_account_type(issue[:assignee][:login], 'github')

      if assignee.nil?
        assignee = DeveloperAccount.new

        assignee.loginid = issue[:assignee][:login]
        assignee.account_type = 'github'

        assignee.save!
      end

      existing_assignment = task.assignments.find_by developer_account: assignee

      if task.new_record? || !existing_assignment
        assignment = Assignment.new
        assignment.task = task
      else
        assignment = existing_assignment
      end

      # assigned_at could be more accurately found in the issue 'events' stream
      assignment.assigned_at = Time.now if assignment.assigned_at

      assignment.developer_account = assignee
    else
      assignment = Assignment.find_by_task_id(task.id)

      # If the assignment exists locally but not in GH, it has been unassigned so we'll delete ours
      assignment.destroy! if assignment
    end

    if issue[:milestone]
      milestone = Milestone.find_by_gh_milestone_number(issue[:milestone][:number])

      task.milestone = milestone
    end

    task.created_at = issue[:created_at]

    task.save!

    assignment.save! if assignment
  end

  # Syncs a single issue from GitHub to the local database
  def sync_milestone(project, gh_milestone)
    # Find or create the milestone locally
    begin
      milestone = project.milestones.find_by_gh_milestone_number(gh_milestone[:number])
    rescue TypeError => e
      Rails.logger.error "Unable to parse milestone data from GitHub: #{e}"
      return
    end

    unless milestone
      milestone = Milestone.new
      milestone.gh_milestone_number = gh_milestone[:number]
      milestone.project = project
      Rails.logger.debug "Importing milestone ##{gh_milestone[:number]} ('#{gh_milestone[:title]}') from GitHub."
    else
      Rails.logger.debug "Updating existing milestone ##{gh_milestone[:number]} ('#{gh_milestone[:title]}') with GitHub."
    end

    milestone.title = gh_milestone[:title]
    milestone.description = gh_milestone[:description]
    milestone.due_on = gh_milestone[:due_on]
    milestone.completed_at = gh_milestone[:closed_at]

    milestone.created_at = gh_milestone[:created_at]

    milestone.save!
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
