class GitHubService
  @_client = nil
  
  # Uses the GitHub API to create a GitHub issue. Returns issue number on successful creation.
  def self.create_issue(task)
    ret = self.client.create_issue task.project.gh_repo_url, task.title, task.details

    return ret[:number]
  end

  # Uses the GitHub API to close a GitHub issue
  def self.close_issue(task)
    ret = self.client.close_issue task.project.gh_repo_url, task.gh_issue_number

    return ret[:state] == "closed"
  end
  
  private
  
    def self.client
      unless @_client
        Octokit.auto_paginate = true
      end

      @_client = Octokit::Client.new :login => $GITHUB_CONFIG["LOGIN"], :password => $GITHUB_CONFIG["TOKEN"]
    end
end
