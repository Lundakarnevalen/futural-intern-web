class PhonesController < ApplicationController

  load_and_authorize_resource

  def new
    @phone = Phone.new
    @method = :post
    render :new
  end

  def create
    phone = Phone.create phone_params
    respond_to do |format|
      format.json do
        render :json =>
          if phone.errors.any?
            { :status => :failure,
              :message => phone.errors.full_messages.join('; ') }
          else
            { :status => :success,
              :id => phone.id }
          end
      end
    end
  end

  def update
    phone = Phone.find params[:id]
    phone.save
    respond_to do |format|
      format.json do
        render :json =>
          if phone.errors.any?
            { :status => :failure,
              :message => phone.errors.full_messages.join('; ') }
          else
            { :status => :success }
          end
      end
    end
  end

  def delete
    Phone.delete params[:id]
    respond_to do |format|
      format.json do
        render :json =>
          { :status => :success }
      end
    end
  end

  def app_stores
    urls = {
      android:"https://play.google.com/store/apps/details?id=se.lundakarnevalen.android" ,
      iphone: "https://itunes.apple.com/se/app/karnevalisten/id811615995?mt=8"
    }
    user_agent = if request.user_agent.downcase.match(/android|iphone/).to_sym
    redirect_to urls[user_agent.to_sym] if user_agent
  end

  private
  def phone_params
    params.require(:phone).permit!
  end
end
