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
    @sektion = Sektion.find(current_user.karnevalist.tilldelad_sektion)
  end

  def create
    @reservation = Reservation.new(reservation_params)
    respond_to do |format|
      if @reservation.save
        format.json { render json: @reservation, status: :created }
      else
        format.json { render json: { errors: @reservation.errors.full_messages } , status: :unprocessable_entity }
      end
    end
  end

  def update
  end

  def destroy
    @reservation.destroy
    redirect_to fabriken_reservations_path
  end

  private
    def find_reservation
      @reservation = Reservation.find(params[:id])
    end

    def reservation_params
      params.require(:reservation).permit!
    end
end
