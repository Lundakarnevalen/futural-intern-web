class Karneblocket::KarneblocketController < ApplicationController
  skip_before_filter :require_login

  skip_authorization_check
  def index
    if signed_in?
      # ToDo: Fulhack följer nedan, hur görs detta på normalt vis?
      render template: 'karneblocket/index'
    else
      redirect_to new_user_session_path
    end
  end
end
