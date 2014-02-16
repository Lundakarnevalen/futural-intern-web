# encoding: utf-8
class NotificationsController < ApplicationController
  require 'gcm'

  before_filter :authenticate_user_from_token!, :except => [:index, :show]
  before_filter :authenticate_user!, :except => [:index, :show]

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
      #Phone.all.each do |p|
      #  if !p.google_token.blank?
      #    registration_ids.push p.google_token
      #  end
      #end
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
      end
      redirect_to :action => 'index'
    else
      render 'new'
    end
  end
end
