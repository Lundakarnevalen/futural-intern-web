# -*- encoding : utf-8 -*-
class Api::ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  before_filter :authenticate_user_from_token!

  def authenticate_user_from_token!
    resource = User.find_by_authentication_token(params[:token])
    return render status: :unauthorized, json: {errors: [t('invalid token')]} unless resource
      # Notice we are passing store false, so the user is not
      # actually stored in the session and a token is needed
      # for every request. If you want the token to work as a
      # sign in token, you can simply remove store: false.
    sign_in resource, store: false
  end

end
