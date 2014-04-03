class Warehouse::IncomingDeliveriesController < Warehouse::ApplicationController
  before_filter :find_incoming_delivery, only: [:show, :update]

  def index
    @incoming_deliveries_ongoing = IncomingDelivery.find_all_by_ongoing(true)
    @incoming_deliveries_ongoing = @incoming_deliveries_ongoing.order("created_at ASC") if !@incoming_deliveries_ongoing.blank?
    @incoming_deliveries_past = IncomingDelivery.find_all_by_ongoing(false)
    @incoming_deliveries_past = @incoming_deliveries_past.order("created_at ASC") if !@incoming_deliveries_past.blank?
  end

  def show
    @incoming_delivery = find_incoming_delivery
  end

  def new
    @incoming_delivery = current_user.karnevalist.incoming_deliveries.new
    @products = Product.all
    @incoming_delivery.incoming_delivery_products.build

  end

  def create
    @incoming_delivery = current_user.karnevalist.incoming_deliveries.new(incoming_delivery_params)
    if @incoming_delivery.save
      redirect_to warehouse_incoming_deliveries_path
    else
      @products = Product.all
      @incoming_delivery.incoming_delivery_products.build
      render :new
    end
  end

  def update
  end

  def delete
  end

  private
    def find_incoming_delivery
      @order = Order.find(params[:id])
    end
    def incoming_delivery_params
      params.require(:incoming_delivery).permit(:invoice_nbr, :ongoing, incoming_delivery_products_attributes: [:id, :_destroy, :amount, :product_id])
    end
end
