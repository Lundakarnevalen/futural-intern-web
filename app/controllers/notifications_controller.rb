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
    api_key = "***REMOVED***"

    if @notification.save
      gcm = GCM.new(api_key)
      registration_ids = Array.new
      Karnevalist.all.each do |k|
        if !k.google_token.blank?
          registration_ids.push k.google_token
        end
      end
      options = {
        'data' => {
          'title' => @notification.title,
          'message' => @notification.message,
          'message_type' => @notification.message_type,
          'created_at' => @notification.created_at
        }
      }
      @response = gcm.send_notification(registration_ids, options)
      redirect_to :action => 'index'
    else
      render 'new'
    end
  end
end
