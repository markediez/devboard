require 'rake'

namespace :user do
  desc 'Adds access token to user.'
  task :grant_access, :arg1 do |t, args|
    Rake::Task['environment'].invoke

    #Authorization.ignore_access_control(true)

    args.each do |arg|
      u = User.find_by_loginid(arg[1])
      if u
        puts "#{arg[1]} already has access. Skipping ..."
      else
        u = User.new
        u.loginid = arg[1]
        u.save!
        puts "Created user #{u.loginid}."
      end
    end

    #Authorization.ignore_access_control(false)
  end

  desc 'Revokes access from user.'
  task :revoke_access, :arg1 do |t, args|
    Rake::Task['environment'].invoke

    args.each do |arg|
      u = User.find_by_loginid(arg[1])
      if u
        puts "Revoking access from #{arg[1]}..."
        u.active = false
        u.save!
      else
        puts "No such user '#{arg[1]}'"
      end
    end
  end
end
