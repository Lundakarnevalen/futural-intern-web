class NotificationsController < ApplicationController
  require 'gcm'

  def index
    @notifications = Notification.all
  end

  def show
    @notification = Notification.find(params[:id])
  end
  
  def new
    @notification = Notification.new
  end

  def create
    @notification = Notification.new(params[:notification])
    api_key = "123456789"

    if @notification.save
      gcm = GCM.new(api_key)
      registration_ids = Array.new
      Karnevalist.all.each do |k|
        registration_ids.push k.google_token
      end
      options = {data: {text: @notification.text}}
      @response = gcm.send_notification(registration_ids, options)
      redirect_to :action => 'index'
    else
      render 'new'
    end
  end
end
