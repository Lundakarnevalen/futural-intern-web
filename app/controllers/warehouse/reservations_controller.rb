class Warehouse::ReservationsController < Warehouse::ApplicationController
  before_filter :find_reservation, only: [:show, :update, :delete]
  def index
    @reservations = Reservation.where(nil)
    @reservations = Reservation.between(params[:start], params[:end]) if params[:start] && params[:end]
    respond_to do |format|
      format.html
      format.json { render json: @reservations }
    end
  end

  def show
  end

  def create
  end

  def update
  end

  def delete
  end

  private
    def find_reservation
      @reservation = Reservation.find(params[:id])
    end
end
