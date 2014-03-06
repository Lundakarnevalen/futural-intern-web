class HomeController < ApplicationController
  skip_authorization_check

  def index
    unless signed_in?
      redirect_to '/users/sign_in'
    end
  end
end
