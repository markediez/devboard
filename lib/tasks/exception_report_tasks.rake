require 'rake'

namespace :exception_report do
  desc 'Checks the exception reports mailbox for new exceptions.'
  task :check_mailbox do
    Rake::Task['environment'].invoke

    check_time_start = Time.now
    Rails.logger.info "Performing exception mail check ..."

    require 'net/imap'
    require 'mail'

    # Login
    imap = Net::IMAP.new(Rails.application.secrets.exception_imap_server, 993, true)
    imap.login(Rails.application.secrets.exception_imap_username, Rails.application.secrets.exception_imap_password)

    # List folders
    # imap.list("", "*")

    # List of recent messages
    # mail = imap.search(["RECENT"])

    # Select the INBOX
    imap.select('INBOX')

    # Grab all messages (except deleted ones, which would show up if we did 'ALL')
    ids = imap.search(['NOT','DELETED'])

    # Loop over each message
    ids.each do |id|
      # Fetch the message by 'id'
      msg = imap.fetch(id, "RFC822")[0].attr['RFC822']
      mail = Mail.read_from_string(msg)

      subject = mail.subject
      body = mail.body.decoded
      from = mail.from[0]
      to = mail.to

      puts "from: #{from}"

      p = Project.find_by(exception_email_from: from)
      if p
        er = ExceptionReport.new
        er.project = p
        er.subject = subject
        er.body = body
        er.duplicate = false
        er.save!

        # Delete the message
        imap.copy(id, 'Deleted Items')
        imap.store(id, "+FLAGS", [:Deleted])
      else
        Rails.logger.warn "Could not find project matching exception address: #{from}. Skipping ..."
        next
      end
    end

    imap.expunge

    imap.logout
    imap.disconnect

    check_time_stop = Time.now
    Rails.logger.info "Finished exception mail check. Took #{(check_time_stop - check_time_start).round(2)}s."
  end
end
