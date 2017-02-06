class SiteController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:credentials]
  skip_before_action :authenticate, only: [:access_denied, :logout]

  # GET /access_denied
  # Unauthenticated requests are redirected here
  def access_denied
  end

  def logout
    CASClient::Frameworks::Rails::Filter.logout(self)
  end

  # GET /credentials
  # POST /credentials
  # Redirects to CAS are made from here so CAS single sign out will then
  # post back to this URL, giving us one safe URL to disable CSRF protection.
  def credentials
  end
end
