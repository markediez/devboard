# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

job_type :envcommand, 'cd :path && RAILS_ENV=:environment :task'

every 1.hour do
  envcommand 'nice -n 10 bundle exec rake github:sync_tasks --silent >/dev/null 2>&1'
  envcommand 'nice -n 10 bundle exec rake github:sync_milestones --silent >/dev/null 2>&1'
  envcommand 'nice -n 10 bundle exec rake github:sync_commits --silent >/dev/null 2>&1'
end

# Learn more: http://github.com/javan/whenever
