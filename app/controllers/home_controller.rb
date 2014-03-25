class HomeController < ApplicationController
  skip_authorization_check

  def index
    if signed_in?
      @sektion = current_user.karnevalist.sektion
      @posts = @sektion.posts
    else
      redirect_to new_karnevalist_path
    end
  end
end
