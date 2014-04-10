class Api::NotificationsController < Api::ApplicationController
  before_filter :authenticate_user_from_token!
  def index
    user = User.where(authentication_token: params[:token]).take
    sektioner = user.karnevalist.tilldelade_sektioner
    sektioner_ids = [0]   # Section_id 0 => show notification for every karnevalist
    sektioner.each do |s|
      sektioner_ids.push s.id
    end
    notifications = Notification.where(recipient_id: sektioner_ids).order("created_at DESC")
    return render status: 204, json: { success: true } if notifications.blank?
    render status: 200, json: { success: true, notifications: notifications.to_json }
  end
end
