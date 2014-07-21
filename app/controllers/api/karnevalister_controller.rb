# -*- encoding : utf-8 -*-
class Api::KarnevalisterController < Api::ApiController
  before_filter :authenticate_user_from_token!
  before_filter :karnevalist_params, only: [:update]
  def update
    g_token = karnevalist_params[:google_token]
    ios_token = karnevalist_params[:ios_token]
    success = false
    if !g_token.blank?
      success = Karnevalist.update(params[:id], google_token: g_token)
    elsif !ios_token.blank?
      success = Karnevalist.update(params[:id], ios_token: ios_token)
    end
    render_response(success)
  end

  def fetch
    k = current_user.karnevalist
    return render status: 404, json: { success: false } if k.blank?
    render status: 200 , json: { success: true, karnevalist: k }
  end

  def search
    unless current_user.is? :exporter
      return render status: :unauthorized, json: {errors: [t('not authorized')]}
    end

    if params[:q].present?
      @results = Karnevalist.search params[:q]
    else
      @results = Karnevalist.order(id: :asc).includes(:sektioner, :intressen)
    end

    render :json =>
      { :status => :success,
        :records => @results.length,
        :remaining => false,
        :karnevalister => @results }
  end

  private
    def karnevalist_params
      params.require(:karnevalist).permit!
    end
    def render_response(success)
      return render status: 400, json: { success: false, errors: 'invalid phone token' } unless success
      render status: 200, json: { success: true }
    end
end
