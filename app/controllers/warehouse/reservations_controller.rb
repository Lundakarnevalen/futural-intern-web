class Warehouse::ReservationsController < Warehouse::ApplicationController
  def index
    @reservations = Reservations.scoped
    @reservations = Reservations.between(params[:start], params[:end]) if params[:start] && params[:end]
    respond_to do |format|
      format.html
      format.json { render json: @reservations }
    end
  end

  def show
  end

  def new
  end

  def create
  end

  def update
  end

  def delete
  end

end
