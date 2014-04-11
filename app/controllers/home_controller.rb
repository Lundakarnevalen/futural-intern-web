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

  def app_store
    urls = {
      android: "https://play.google.com/store/apps/details?id=se.lundakarnevalen.android",
      ios: "https://itunes.apple.com/se/app/karnevalisten/id811615995?mt=8"
    }
    user_agent = request.user_agent.downcase.match(/android|iphone/).to_s
    redirect_to urls[user_agent.to_sym] if user_agent
  end

end
