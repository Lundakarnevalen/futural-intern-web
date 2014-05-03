# -*- encoding : utf-8 -*-
#encoding: UTF-8

class HomeController < ApplicationController
  skip_before_filter :require_login

  skip_authorization_check
  def index
    if signed_in?
      @posts = Post.includes(:sektion)
      @posts.delete_if do |post|
        !(current_sektioner.include?(post.sektion) || post.sektion.nil?) unless can? :manage, post
      end
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

  def markdown

  end
end
