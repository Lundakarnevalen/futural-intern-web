# -*- encoding : utf-8 -*-
class Api::TrainPositionsController < Api::ApiController
  before_filter :authenticate_user_from_token!, except: [:index, :show]
  before_filter :find_train_position, only: [:show, :update]
  before_filter :authorize_write, only: [:create, :update]

  def index
    postions = TrainPosition.all
    return render status: 204, json: { success: true } if postions.blank?
    render status: 200, json: { success: true, train_positions: postions }
  end

  def show
    render status: 200, json: { success: true, train_position: @position }
  end

  def create
    @position = TrainPosition.new(train_position_params)
    render_response(@position.save, 201)
  end

  def update
    @position = TrainPosition.find(params[:id])
    render_response(@position.update_attributes(train_position_params), 200)
  end

  private
    def train_position_params
      params.require(:train_position).permit!
    end

    def authorize_write
      return render status: 401, json: { success: false } unless current_user.is?(:train_man)
    end

    def find_train_position
      @position = TrainPosition.find(params[:id])
    end

    def render_response(success, status_code)
      return render status: 400, json: { success: false, errors: @position.errors.full_messages } unless success
      render status: status_code, json: { success: true, train_position: @position }
    end
end
