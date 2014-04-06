class HomeController < ApplicationController
  skip_authorization_check
  layout 'home/application'

  def index
    if signed_in?
      if current_user.karnevalist? &&
         !current_user.karnevalist.tilldelade_sektioner.blank?
        @sektioner = current_user.karnevalist.tilldelade_sektioner
        @posts = @sektioner.map { |s| s.posts }.flatten
        @post = current_user.karnevalist.sektion.posts.build
      end
    else
      redirect_to new_user_session_path
    end
  end
end
