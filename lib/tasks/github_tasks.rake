require 'rake'

namespace :github do
  desc 'Run all regularly scheduled GitHub tasks.'
  task :run => :environment do
    sync_tasks
    sync_commits
  end
  
  def sync_tasks
    Task.where(Task.arel_table[:gh_issue_number].not_eq(nil)).each do |task|
      # something ...
    end
  end
  
  def sync_commits
    Developer.where(Developer.arel_table[:gh_personal_token].not_eq(nil)).each do |developer|
      # something involving: ActivityLog.create!({developer_id: current_user.developer_id, project_id: @project.id, activity_type: :committed })
    end
  end
end
