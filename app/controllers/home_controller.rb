class HomeController < ApplicationController
  skip_authorization_check

  def index
    if signed_in?
      if current_user.karnevalist? && 
         !current_user.karnevalist.tilldelade_sektioner.blank?
        @sektioner = current_user.karnevalist.tilldelade_sektioner
      end
    else
      redirect_to new_user_session_path
    end
  end
end
