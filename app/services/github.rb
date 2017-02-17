class GitHubService
  @_client = nil

  # Uses the GitHub API to create a GitHub issue. Returns issue number on successful creation.
  def self.create_issue(task, url)
    ret = self.client.create_issue url, task.title, task.details

    return ret[:number]
  end

  # Uses the GitHub API to close a GitHub issue.
  # Returns true on success, false on error or unauthorized.
  def self.close_issue(task)
    begin
      ret = self.client.close_issue task.repository.url, task.gh_issue_number

      return ret[:state] == "closed"
    rescue Octokit::Unauthorized => e
      Rails.logger.error "GitHub indicates no authorization when closing issue: #{e}"
      return false
    end
  end

  def self.reopen_issue(task)
    begin
      ret = self.client.reopen_issue task.repository.url, task.gh_issue_number

      return ret[:state] == "open"
    rescue Octokit::Unauthorized => e
      Rails.logger.error "GitHub indicates no authorization when opening issue: #{e}"
      return false
    end
  end

  # Return all issues (opened and closed) given a project URL, e.g. 'dssit/devboard'
  def self.find_issues_by_project(url)
    self.client.list_issues(url, { :state => 'all' })
  end

  # Return all commits given a project URL, e.g. 'dssit/devboard'.
  # Optionally pass a branch, defaults to 'master'.
  def self.find_commits_by_project(url, branch = 'master')
    self.client.commits(url, branch)
  end

  # Return all commits given a project URL, e.g. 'dssit/devboard' since a given date.
  # Optionally pass a branch, defaults to 'master'.
  def self.find_commits_by_project_since(url, since, branch = 'master')
    self.client.commits_since(url, since.strftime("%Y-%m-%d"), branch)
  end

  # Returns a single commit given a project URL, e.g. 'dssit/devboard' and SHA1.
  def self.find_commit_by_project_and_sha(url, sha)
    self.client.commit(url, sha)
  end

  # Return all milestones (opened and closed) given a project URL, e.g. 'dssit/devboard'.
  def self.find_milestones_by_project(url)
    self.client.list_milestones(url, { :state => 'all' })
  end

  # Return all branches for given a project URL, e.g. 'dssit/devboard'.
  # Returns false on error.
  def self.find_branches_by_project(url)
    branches = self.client.branches(url)
    if branches
      return branches.map{|b| b.name}
    else
      return false
    end
  end

  private

    def self.client
      unless @_client
        Octokit.auto_paginate = true
      end

      stack = Faraday::RackBuilder.new do |builder|
      builder.response :logger
        builder.use Octokit::Response::RaiseError
        builder.adapter Faraday.default_adapter
      end
      Octokit.middleware = stack

      @_client = Octokit::Client.new(:login => $GITHUB_CONFIG["LOGIN"], :password => $GITHUB_CONFIG["TOKEN"])
    end
end
