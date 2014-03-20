class Api::TestController < Api::ApplicationController
  before_filter :authenticate_user_from_token!
  def index
    render json: {success: true, message: 'Token authenticated'}, status: 200
  end
end
