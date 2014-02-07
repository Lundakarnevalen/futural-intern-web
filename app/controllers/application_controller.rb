class ApplicationController < ActionController::Base
  protect_from_forgery :with => :null_session
  before_filter :mail_default_url

  private

  def mail_default_url
    ActionMailer::Base.default_url_options = {:host => request.host_with_port}
  end

  def authenticate_user_from_token!
    user_token = params[:token].presence
    user       = user_token && User.find_by_authentication_token(user_token.to_s)

    if user
      # Notice we are passing store false, so the user is not
      # actually stored in the session and a token is needed
      # for every request. If you want the token to work as a
      # sign in token, you can simply remove store: false.
      sign_in user, store: false
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
end
