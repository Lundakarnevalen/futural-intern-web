# -*- encoding : utf-8 -*-
class Api::AuthenticationController < Devise::SessionsController
  include Devise::Controllers::Helpers
  skip_before_filter :verify_authenticity_token, if: Proc.new { |c| c.request.format == 'application/json' }
  respond_to :json

  def validate_auth_token
    @resource = User.find_by_authentication_token(params[:token])
    render status: :unauthorized, json: {errors: [t('invalid token')]} if @resource.nil?
  end
end
