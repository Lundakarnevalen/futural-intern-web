class HomeController < ApplicationController
  skip_authorization_check

  def index
    if signed_in? && current_user.karnevalist?
      unless current_user.karnevalist.tilldelade_sektioner.blank?
        @sektioner = current_user.karnevalist.tilldelade_sektioner
        #@posts = @sektioner.map { |s| s.posts }.flatten
        #@post = current_user.karnevalist.sektion.posts.build
      end
    else
      redirect_to new_karnevalist_path
    end
  end
end
