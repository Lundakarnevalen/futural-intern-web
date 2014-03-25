class HomeController < ApplicationController
  skip_authorization_check

  def index
    if signed_in?
      unless current_user.karnevalist.sektion.nil?
        @sektion = current_user.karnevalist.sektion
        @posts = @sektion.posts
      end
    else
      redirect_to new_karnevalist_path
    end
  end
end
