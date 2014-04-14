#encoding: UTF-8

class HomeController < ApplicationController
  skip_authorization_check
  def index
    if signed_in?
      @posts = Post.includes(:sektion)
      @posts.delete_if do |post|
        !(current_sektioner.include?(post.sektion) || post.sektion.nil?)
      end
      #@sektioner = current_sektioner
      #@posts = @sektioner.map { |s| s.posts }.flatten
      #@posts.sort_by! { |p| p.created_at }.reverse!
      #@post = current_user.karnevalist.sektion.posts.build
    else
      redirect_to new_user_session_path
    end
  end

  def app_store
    urls = {
      android: "market://details?id=se.lundakarnevalen.android",
      iphone: "https://itunes.apple.com/se/app/karnevalisten/id811615995?mt=8"
    }
    user_agent = request.user_agent.downcase.match(/android|iphone/).to_s
    redirect_to urls[user_agent.to_sym] unless user_agent.blank?
  end

end
