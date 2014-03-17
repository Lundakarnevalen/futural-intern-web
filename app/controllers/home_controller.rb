class HomeController < ApplicationController
  skip_authorization_check

  def index
    unless signed_in?
      redirect_to new_karnevalist_path 
    end
  end
end
