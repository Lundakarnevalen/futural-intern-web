# -*- encoding : utf-8 -*-
class Api::TrainPositionsController < Api::ApiController
  authorize_resource
  skip_authorize_resource only: [:index, :show]
  before_filter :authenticate_user_from_token!, except: [:index, :show]
  before_filter :find_train_position, only: [:show, :update]

  def index
    postions = TrainPosition.all
    return render status: 204, json: { success: true } if postions.blank?
    render status: 200, json: { success: true, train_postions: postions }
  end

  def show
    render status: 200, json: { success: true, train_postion: @position }
  end

  def create
    @position = TrainPosition.new(train_postion_params)
    render_response(@postion.save, success_code)
  end

  def update
    @position = TrainPosition.find(params[:id])
    render_response(@position.update_attributes(train_position_params))
  end

  private
    def train_position_params
      params.require(:train_position).permit!
    end

    def find_train_position
      @position = TrainPosition.find(params[:id])
    end

    def render_response(success, success_code = 200)
      return render status: 400, json: { success: false, errors: @position.errors.full_messages } unless success
      render status: success_code, json: { success: true, train_position: @position }
    end
end
