class Api::SessionsController < Api::AuthenticationController
  prepend_before_filter :require_no_authentication, only: :create
  before_filter :validate_auth_token, except: :create

  def create
    resource = User.find_for_database_authentication(email: params[:user][:email])
    return invalid_credentials unless resource

    if resource.valid_password?(params[:user][:password])
      sign_in(:user, resource, store: false)
      resource.ensure_authentication_token
      render json: { success: true, token: resource.authentication_token, karnevalist: resource.karnevalist }
      return
    end
    invalid_credentials
  end

  def destroy
    @resource.reset_authentication_token!
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    render status: 200, :json => {}
  end

  private
    def invalid_credentials
      return render json: { success: false, errors: [t('Incorrect email or password')] }, status: :unauthorized
    end

end
