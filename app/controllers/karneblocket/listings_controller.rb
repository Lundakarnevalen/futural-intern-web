class Karneblocket::ListingsController < ApplicationController
  skip_before_filter :require_login

  skip_authorization_check
  def index
    if signed_in?

    else
      redirect_to new_user_session_path
    end
  end

  def new
  end

  def create
    render text: params[:listing].inspect
  end
end
