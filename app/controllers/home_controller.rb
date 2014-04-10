#encoding: UTF-8

class HomeController < ApplicationController
  skip_authorization_check
  def index
    if signed_in?
      if current_user.karnevalist? &&
         !current_user.karnevalist.tilldelade_sektioner.blank?
        @sektioner = current_user.karnevalist.tilldelade_sektioner
        @posts = @sektioner.map { |s| s.posts }.flatten
        @posts.sort_by! { |p| p.created_at }.reverse!
        @post = current_user.karnevalist.sektion.posts.build
        if @posts.empty?
          @posts << Post.new(title: "Hoppsan!", content: "Din sektions kommunikationsnisse har inte lagt upp något här än :(", sektion: @sektioner.first)
        end
      end
    else
      redirect_to new_user_session_path
    end
  end
end
