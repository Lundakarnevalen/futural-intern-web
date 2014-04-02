# encoding: utf-8
class NotificationsController < ApplicationController
  require 'gcm'

  before_filter :authenticate_user_from_token!, :except => [:index, :show]
  before_filter :authenticate_user!, :except => [:index, :show]
  skip_before_filter :can_can_strong, only: [:index, :show]
  load_and_authorize_resource

  def index
    sektioner = current_user.karnevalist.tilldelade_sektioner
    sektioner_ids = [0]   # Section_id 0 => show notification for every karnevalist 
    sektioner.each do |s|
      sektioner_ids.push s.id
    end
    @notifications = Notification.where(recipient_id: sektioner_ids).order("created_at DESC")
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
    gcm_api_key = "AIzaSyCLMSbP2XW1dChD90iRXNbvdmHC9B7zavI"

    if @notification.save
      gcm = GCM.new(gcm_api_key)
      pusher = Grocer.pusher(certificate: Rails.root.join("config", "certificate.pem"), gateway: "gateway.push.apple.com")
      registration_ids = Array.new
      if @notification.recipient_id == 0
        karnevalister = Karnevalist.where("tilldelad_sektion IS NOT NULL")
      else
        karnevalister = Karnevalist.where("tilldelad_sektion = ? OR tilldelad_sektion2 = ?", @notification.recipient_id, @notification.recipient_id)
      end
      karnevalister.each do |k|
        if !k.google_token.blank?
          registration_ids.push k.google_token
        elsif !k.ios_token.blank?
          ios_notification = Grocer::Notification.new(device_token: k.ios_token, alert: @notification.title, sound: 'default', badge: 0)
          pusher.push(ios_notification)
        end
      end
      registration_ids.each_slice(1000) do |reg_ids|
        options = {
          'data' => {
            'id' => @notification.id,
            'title' => @notification.title,
            'message' => @notification.message,
            'recipient_id' => @notification.recipient_id,
            'message_type' => '0',
            'created_at' => @notification.created_at.strftime("%Y-%m-%d %H:%M")
          }
        }
        @response = gcm.send_notification(reg_ids, options)
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
