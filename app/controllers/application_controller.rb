class ApplicationController < ActionController::Base
  protect_from_forgery :with => :null_session
  before_filter :mail_default_url

  check_authorization :unless => :devise_controller?
  before_filter :can_can_strong

  layout :layout

  def redirect_to(options = {}, response_status = {})
    ::Rails.logger.error("Redirected by #{caller(1).first rescue "unknown"}")
    super(options, response_status)
  end

  def can_can_strong
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end

  # Neat error handling.

  def handle_errors res, msg, opts = {}
    opts = { :redirect => res }.merge opts

    if res.errors.any?
      flash[:alert] = res.errors.full_messages.join '; '
      redirect_to :back
    else
      flash[:notice] = msg
      redirect_to opts[:redirect]
    end
  end

  # Much needed
  helper_method :current_karnevalist

  def current_karnevalist
    current_user && current_user.karnevalist
  end

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

  def after_sign_out_path_for _
    new_user_session_path
  end

  def layout
    # turn layout off for every devise controller:
    "login" if devise_controller?
  end
end
