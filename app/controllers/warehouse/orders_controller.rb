class Warehouse::OrdersController < Warehouse::ApplicationController
    before_filter :find_order, only: [:show, :update]
  def index
    @orders = Order.where(karnevalist_id: current_user.karnevalist.id)
  end

  def show
    @order = find_order
    respond_to do |format|
      format.html
      format.pdf do
        pdf = ReceiptPdf.new(@order, view_context)
        send_data pdf.render, filename:
        "order_#{@order.created_at.strftime("%d/%m/%Y")}.pdf",
        type: "application/pdf", disposition: "inline"
      end
    end
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

  def list
    @orders = Order.all
    render :index
  end

  def calendar
    @orders = Order.where.not(delivery_date: nil)
  end

  def update
  end

  def delete
  end

  def search
    @orders = Order.search(params[:search_param])
    render :index
  end  

  private
    def find_order
      @order = Order.find(params[:id])
    end
    def order_params
      params.require(:order).permit(:status, :delivery_date, :comment, order_products_attributes: [:id, :_destroy, :amount, :product_id])
    end
end
