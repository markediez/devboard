require 'rake'

namespace :exception_report do
  desc 'Checks the exception reports mailbox for new exceptions.'
  task :check_mailbox do
    Rails.logger = Logger.new(STDOUT)
    Rake::Task['environment'].invoke

    check_time_start = Time.now
    Rails.logger.info "Performing exception mail check ..."

    require 'net/imap'
    require 'mail'

    # Login
    imap = Net::IMAP.new(Rails.application.secrets.exception_imap_server, 993, true)
    imap.login(Rails.application.secrets.exception_imap_username, Rails.application.secrets.exception_imap_password)

    # Select the INBOX
    imap.select('INBOX')

    # Grab all messages (except deleted ones, which would show up if we did 'ALL')
    ids = imap.search(['NOT','DELETED'])

    filters = ExceptionFilter.all

    # Loop over each message
    ids.each do |id|
      # Fetch the message by 'id'
      msg = imap.fetch(id, "RFC822")[0].attr['RFC822']
      mail = Mail.read_from_string(msg)

      er = ExceptionReport.new
      er.subject = mail.subject
      er.body = mail.body.decoded
      er.duplicated_id = nil
      er.email_from = mail.from[0]

      # Apply any filters
      filters.each do |f|
        f.apply(er)
      end

      er.save!

      # Delete the message only on production
      if Rails.env.production?
        imap.copy(id, 'Deleted Items')
        imap.store(id, "+FLAGS", [:Deleted])
      end
    end

    imap.expunge

    imap.logout
    imap.disconnect

    check_time_stop = Time.now
    Rails.logger.info "Finished exception mail check. Took #{(check_time_stop - check_time_start).round(2)}s."
  end
end
