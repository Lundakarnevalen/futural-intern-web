class Warehouse::OrdersController < Warehouse::ApplicationController
    before_filter :find_order, only: [:show, :update]
  def index
    @orders = Order.all.order("created_at DESC")
  end

  def show
  end

  def new
    @order = Order.new
    @products = Product.all
  end

  def create
    order = Order.new(order_params)
    if order.save
      redirect_to order
    else
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
      params.require(:order).permit!
    end
end
