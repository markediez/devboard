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

every 30.minutes do
  envcommand 'nice -n 10 bundle exec rake github:run --silent'
end

# Learn more: http://github.com/javan/whenever
