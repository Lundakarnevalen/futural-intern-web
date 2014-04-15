# -*- encoding : utf-8 -*-
class Api::ApiController < ActionController::Base
  protect_from_forgery with: :null_session
  def authenticate_user_from_token!
    user_token = params[:token].presence
    user       = user_token && User.find_by_authentication_token(user_token.to_s)

    if user
      sign_in user, store: false
    else
      render status: :unauthorized, json: {errors: [t('invalid token')]}
    end

  end
end
