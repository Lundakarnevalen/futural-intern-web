class Api::KarnevalisterController < Api::ApiController
  before_filter :authenticate_user_from_token!
  before_filter :karnevalist_params
  def update
    success = Karnevalist.update(params[:id], karnevalist_params)
    render_response(success)
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
