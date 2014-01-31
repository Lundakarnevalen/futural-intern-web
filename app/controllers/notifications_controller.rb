class NotificationsController < ApplicationController
  require 'gcm'

  def index
    @notifications = Notification.all
    respond_to do |format|
      format.html{ render }
      format.json do
        render :json => 
          { :status => :success,
            :records => @notifications.length,
            :remaining => false,
            :notifications => @notifications }
      end
    end
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
      registration_ids = Array.new # kan maximalt innehålla 1000 enheter (lös med for-loop)
      Karnevalist.all.each do |k|
        if !k.google_token.blank?
          registration_ids.push k.google_token
        end
      end
      options = {
        'data' => {
          'id' => @notification.id,
          'title' => @notification.title,
          'message' => @notification.message,
          'message_type' => '0',
          'created_at' => @notification.created_at.strftime("%Y-%m-%d %H:%M")
        }
      }
      @response = gcm.send_notification(registration_ids, options)
      redirect_to :action => 'index'
    else
      render 'new'
    end
  end
end
