# -*- encoding : utf-8 -*-
class Warehouse::OrdersController < Warehouse::ApplicationController
  before_filter :find_order, only: [:show, :update, :confirm, :confirm_put]

  def index
    @active_orders = Order.where("status IS NOT NULL AND finished_at IS NULL AND warehouse_code = ? AND karnevalist_id = ?", @warehouse_code, current_user.karnevalist.id).order("id DESC")
    @completed_orders = Order.where("status IS NOT NULL AND finished_at IS NOT NULL AND warehouse_code = ? AND karnevalist_id = ?", @warehouse_code, current_user.karnevalist.id).order("id DESC")
    @bestallare = true
  end

  def show
    @partial_delivery = PartialDelivery.new 
    @partial_delivery.partial_delivery_products.build
    @bestallare = true if @order.karnevalist_id == current_user.karnevalist.id
    @levererad = false
    @makulerad = false
    @part_delivered = false
    @partial_deliveries = PartialDelivery.where("order_id = ?", @order.id).order("id DESC")

    # TODO Detta borde vara en metod i modellen.
    if @order.status == "Levererad"
        @levererad = true;
    elsif @order.status == "Makulerad" || @order.status == "Dellevererad/Makulerad"
        @makulerad = true
    elsif @order.status == "Dellevererad"
        @part_delivered = true
    end
    ##
    respond_to do |format|
      format.html
      format.pdf do
        pdf = generate_pdf(@order, view_context, @warehouse_code)
        send_data pdf.render, filename:
        "order_#{@order.created_at.strftime("%Y-%m-%d")}.pdf",
        type: "application/pdf", disposition: "inline"
      end
    end
  end

  def new
    @bestallare = true
    @product_categories = ProductCategory.where(warehouse_code: @warehouse_code).order("name ASC")
    @order = current_user.karnevalist.orders.new
    @order.order_products.build
  end

  def create
    @order = current_user.karnevalist.orders.new(order_params)
    @order.sektion = Sektion.find(current_user.karnevalist.tilldelad_sektion)
    @order.warehouse_code = @warehouse_code
    if @order.save
      redirect_to confirm_order_path(@order)
    else
      @bestallare = true
      @product_categories = ProductCategory.where(warehouse_code: @warehouse_code).order("name ASC")
      @order.order_products.build
      render :new
    end
  end

  def confirm
  end

  def confirm_put
    if params[:confirm]
      @order.status = "Bearbetas"
    end
    if @order.update_attributes(order_params)
        @order.order_products.each do |order_product|
          product = Product.find(order_product.product_id)
          in_stock = product.stock_balance_not_ordered
          if in_stock == 0
            stock_balance_stand_by = product.stock_balance_stand_by + order_product.amount.to_i
            product.update_attributes(:stock_balance_stand_by => stock_balance_stand_by)
          elsif in_stock >= order_product.amount.to_i
            stock_balance_ordered = product.stock_balance_ordered + order_product.amount.to_i
            in_stock -= order_product.amount.to_i
            product.update_attributes(:stock_balance_ordered => stock_balance_ordered, :stock_balance_not_ordered => in_stock)
          else
            stock_balance_ordered = product.stock_balance_ordered + in_stock
            stock_balance_stand_by = order_product.amount.to_i - in_stock
            product.update_attributes(:stock_balance_ordered => stock_balance_ordered, :stock_balance_stand_by => stock_balance_stand_by, :stock_balance_not_ordered => 0)
          end
        end
      redirect_to order_path(@order)
    else
      render :confirm
    end
  end

  def direct_selling
    @customers = Array.new
    @product_categories = ProductCategory.where(warehouse_code: @warehouse_code).order("name ASC")
    @order = Order.new
    @order.order_products.build
  end

  def direct_selling_post
    @order = Order.new(order_params)
    @order.warehouse_code = @warehouse_code
    @order.finished_at = DateTime.now
    @order.status = "Levererad"
    if @order.save
      partial_delivery = @order.partial_deliveries.new(seller_id: current_user.karnevalist.id)
      partial_delivery.save
      @order.order_products.each do |order_product|
        product = Product.find(order_product.product_id)
        in_stock = product.stock_balance_not_ordered
        if in_stock >= order_product.amount
          in_stock -= order_product.amount
          product.update_attributes(:stock_balance_not_ordered => in_stock)
          order_product.update_attributes(:delivered_amount => order_product.amount)
          partial_delivery.partial_delivery_products.create(product_id: product.id, amount: order_product.amount)
        end
      end
      redirect_to order_path(@order)
    else
      @customers = Array.new
      @product_categories = ProductCategory.where(warehouse_code: @warehouse_code).order("name ASC")
      @order.order_products.build
      render :direct_selling
    end
  end

  def update_customers
    sektion = params[:sektion_id].to_i
    if @warehouse_code == 0
      @roles = Role.where(name: ["bestallare_fabriken", "admin_fabriken"])
    else
      @roles = Role.where(name: ["bestallare_festmasteriet", "admin_festmasteriet", "kassor_festmasteriet"])
    end
    @customers = Array.new
    @roles.each do |r|
      r.users.each do |u|
        @customers.push u.karnevalist if u.karnevalist.tilldelad_sektion == sektion
      end
    end
  end

  def list
    if params[:sektion_id]
      redirect_to sektion_orders_path(:sektion_id => params[:sektion_id])
    else
      @active_orders = Order.where("status IS NOT NULL AND finished_at IS NULL AND warehouse_code = ?", @warehouse_code).order("delivery_date ASC, id DESC")
      @completed_orders = Order.where("status IS NOT NULL AND finished_at IS NOT NULL AND warehouse_code = ?", @warehouse_code).order("finished_at ASC")
      @bestallare = false
      render :index
    end
  end
  
  def sektion
    @sektion = Sektion.find(params[:sektion_id])
    @active_orders = Order.where("status IS NOT NULL AND finished_at IS NULL AND warehouse_code = ? AND sektion_id = ?", @warehouse_code, params[:sektion_id]).order("id DESC")
    @completed_orders = Order.where("status IS NOT NULL AND finished_at IS NOT NULL AND warehouse_code = ? AND sektion_id = ?", @warehouse_code, params[:sektion_id]).order("id DESC")
    @bestallare = false
    @sektion_orders = true
    render :index
  end

  def calendar
    @orders = Order.where("delivery_date IS NOT NULL AND warehouse_code = ?", @warehouse_code)
  end

  def return_products
    params['return_amount'].each do |product_id, return_amount|
      if !return_amount.blank?
        product = Product.find(product_id)
        stand_by = product.stock_balance_stand_by
        order_products = OrderProduct.where(:order_id => params['order_id'], :product_id => product_id)
        order_products.each do |order_product|
          if (order_product.delivered_amount >= return_amount.to_i)
            if stand_by == 0
              stock_balance_not_ordered = product.stock_balance_not_ordered + return_amount.to_i
              product.update_attributes(:stock_balance_not_ordered => stock_balance_not_ordered)
            elsif stand_by >= return_amount.to_i
              stock_balance_ordered = product.stock_balance_ordered + return_amount.to_i
              stand_by -= return_amount.to_i
              product.update_attributes(:stock_balance_ordered => stock_balance_ordered, :stock_balance_stand_by => stand_by)
            else
              stock_balance_ordered = product.stock_balance_ordered + stand_by
              stock_balance_not_ordered = return_amount.to_i - stand_by
              product.update_attributes(:stock_balance_ordered => stock_balance_ordered, :stock_balance_not_ordered => stock_balance_not_ordered, :stock_balance_stand_by => 0)
            end
            order_product_amount = order_product.amount - return_amount.to_i
            order_product.update_attributes(:amount => order_product_amount, :delivered_amount => order_product_amount)
          end
        end
      end
    end
    redirect_to order_path(@order)
  end

  def edit
    redirect_to order_path(params[:id])
  end

  def update
    if params[:order][:status]
      @order.update_attributes(order_params)
      if (@order.status == "Makulerad") || (@order.status == "Dellevererad/Makulerad")
        update_warehouse(@order.id)
        @order.finished_at = DateTime.now
        @order.save
      elsif @order.status == "Levererad"
        partial_delivery = @order.partial_deliveries.new(seller_id: current_user.karnevalist.id)
        partial_delivery.save
        @order.order_products.each do |order_product|
          product = Product.find(order_product.product_id)
          amount = order_product.amount - order_product.delivered_amount
          in_stock = product.stock_balance_ordered
          if in_stock >= amount
            in_stock -= amount
            product.update_attributes(:stock_balance_ordered => in_stock)
            order_product.update_attributes(:delivered_amount => order_product.amount)
            partial_delivery.partial_delivery_products.create(product_id: product.id, amount: amount)
          end
        end
        @order.finished_at = DateTime.now
        @order.save
      end
    end
    redirect_to order_path(@order)
  end

  def delete
  end

  def search
    @orders = Order.where(warehouse_code: @warehouse_code).search(params[:search_param])
    @orders = @orders.order("status DESC") if !@orders.blank?
    render :index
  end

  private
    def find_order
      @order = Order.find(params[:id])
    end
    def order_params
      params.require(:order).permit(:warehouse_code, :status, :delivery_date, :comment, :sektion_id, :karnevalist_id, order_products_attributes: [:id, :_destroy, :amount, :product_id])
    end
    def update_warehouse order_id
      order_products = OrderProduct.where(:order_id => order_id)
      order_products.each do |o|
        product = Product.find(o.product_id)
        stand_by = product.stock_balance_stand_by
        return_amount = o.amount - o.delivered_amount
        stock_balance_ordered = product.stock_balance_ordered - return_amount.to_i
        product.update_attributes(:stock_balance_ordered => stock_balance_ordered)
        if stand_by == 0
          stock_balance_not_ordered = product.stock_balance_not_ordered + return_amount.to_i
          product.update_attributes(:stock_balance_not_ordered => stock_balance_not_ordered)
        elsif stand_by >= return_amount.to_i
          stock_balance_ordered = product.stock_balance_ordered + return_amount.to_i
          stand_by -= return_amount.to_i
          product.update_attributes(:stock_balance_ordered => stock_balance_ordered, :stock_balance_stand_by => stand_by)
        else
          stock_balance_ordered = product.stock_balance_ordered + stand_by
          stock_balance_not_ordered = return_amount.to_i - stand_by
          product.update_attributes(:stock_balance_ordered => stock_balance_ordered, :stock_balance_not_ordered => stock_balance_not_ordered, :stock_balance_stand_by => 0)
        end
      end
    end
end
