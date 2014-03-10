class HomeController < ApplicationController
  skip_authorization_check

  def index
    unless signed_in?
      redirect_to '/karnevalister/new'
    end
  end
end
