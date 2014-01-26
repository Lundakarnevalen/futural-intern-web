class ApplicationController < ActionController::Base
  protect_from_forgery :with => :null_session
  before_filter :mail_default_url

  def mail_default_url
    ActionMailer::Base.default_url_options = {:host => request.host_with_port}
  end
end
