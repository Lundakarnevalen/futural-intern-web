class HomeController < ApplicationController
  skip_authorization_check

  def index
    if signed_in?
      unless current_user.karnevalist.sektion.nil?
        @sektioner = current_user.karnevalist.tilldelade_sektioner
        @posts = @sektioner.map { |s| s.posts }.flatten
      end
    else
      redirect_to new_karnevalist_path
    end
  end
end
