class Warehouse::OrdersController < Warehouse::ApplicationController
    before_filter :find_order, only: [:show, :update]
  def index
    @orders = Order.where("karnevalist_id = ?", current_user.karnevalist.id)
  end

  def show
  end

  def new
    @products = Product.all
    @order = current_user.karnevalist.orders.new
    @order.order_products.build
  end

  def create
    @order = current_user.karnevalist.orders.new(order_params)
    if @order.save
      redirect_to warehouse_orders_path
    else
      @products = Product.all
      @order.order_products.build
      render :new
    end
  end

  def update
  end

  def delete
  end

  private
    def find_order
      @order = Order.find(params[:id])
    end
    def order_params
      params.require(:order).permit(:status, :delivery_date, :comment, order_products_attributes: [:id, :_destroy, :amount, :product_id])
    end
end
