# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

# Set up UCD CAS support
CASClient::Frameworks::Rails::Filter.configure(
  :cas_base_url => "https://cas.ucdavis.edu/cas/",
  :enable_single_sign_out => true#,
  #:ticket_store => :active_record_ticket_store
)
