# encoding: utf-8
class NotificationsController < ApplicationController
  require 'gcm'

  before_filter :authenticate_user_from_token!, :except => [:index, :show]
  before_filter :authenticate_user!, :except => [:index, :show]
  skip_before_filter :can_can_strong, only: [:index, :show]
  load_and_authorize_resource

  def index
    @notifications = Notification.all.order("created_at DESC")
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
    @notification = Notification.new notification_params
    gcm_api_key = "***REMOVED***"

    if @notification.save
      gcm = GCM.new(gcm_api_key)
      pusher = Grocer.pusher(certificate: Rails.root.join("config", "certificate.pem"), gateway: "gateway.sandbox.push.apple.com", sound: "default")
      registration_ids = Array.new
      ios_notifications = Array.new
      Karnevalist.all.each do |k|
        if !k.google_token.blank?
          registration_ids.push k.google_token
        elsif !k.ios_token.blank?
          ios_notification = Grocer::Notification.new(
            device_token: k.ios_token,
            alert: @notification.title,
            sound: 'default',
            badge: 0
          )
          ios_notifications.push ios_notification
        end
      end
      registration_ids.each_slice(1000) do |reg_ids|
        options = {
          'data' => {
            'id' => @notification.id,
            'title' => @notification.title,
            'message' => @notification.message,
            'message_type' => '0',
            'created_at' => @notification.created_at.strftime("%Y-%m-%d %H:%M")
          }
        }
        @response = gcm.send_notification(reg_ids, options)
        ios_notifications.each do |notification|
          pusher.push(notification)
        end
      end
      redirect_to :action => 'index'
    else
      render 'new'
    end
  end

  private
  def notification_params
    params.require(:notification).permit!
  end
end
