class Warehouse::OrdersController < Warehouse::ApplicationController
    before_filter :find_order, only: [:show, :update]
  def index
    @orders = Order.where(karnevalist_id: current_user.karnevalist.id).order("status DESC")
  end

  def show
    @order = find_order
    @levererad = false
    @makulerad = false
    @part_delivered = false
    if !params[:status].blank?
      @order.update_attributes(status: params[:status])
    end

    if @order.status == "Levererad"
        @levererad = true;
    elsif @order.status == "Makulerad"
        @makulerad = true
    elsif @order.status == "Dellevererad"
        @part_delivered = true
    end
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
    @order.status = "Bearbetas"
    if @order.save
      redirect_to orders_path
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

  def return_products
    params['return_amount'].each do |product_id, return_amount|
      if !return_amount.blank?
        product = Product.where(:id => product_id).first
        stand_by = product.stock_balance_stand_by
        order_products = OrderProduct.where(:order_id => params['order_id'], :product_id => product_id)
        order_products.each do |order_product|
          if (product.amount(params['order_id']) >= return_amount.to_i)
            if stand_by == 0
              stock_balance_not_ordered = product.stock_balance_not_ordered + return_amount.to_i
              product.update_attributes(:stock_balance_not_ordered => stock_balance_not_ordered)   
            elsif stand_by >= new_amount.to_i
              stock_balance_ordered = product.stock_balance_ordered + return_amount.to_i
              stand_by -= return_amount.to_i
              product.update_attributes(:stock_balance_ordered => stock_balance_ordered)
              product.update_attributes(:stock_balance_stand_by => stand_by)
            else
              stock_balance_ordered = product.stock_balance_ordered + stand_by
              stock_balance_not_ordered = return_amount.to_i - stand_by
              product.update_attributes(:stock_balance_ordered => stock_balance_ordered)
              product.update_attributes(:stock_balance_not_ordered => stock_balance_not_ordered)
              product.update_attributes(:stock_balance_stand_by => 0)
            end
            order_product.amount = order_product.amount - return_amount.to_i
            order_product.update_attributes(:amount => order_product.amount)
          end
        end  
      end
    end
    redirect_to orders_path
  end

  def update
  end

  def delete
  end

  def search
    @orders = Order.search(params[:search_param]).order("status DESC")
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
