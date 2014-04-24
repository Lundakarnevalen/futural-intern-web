# -*- encoding : utf-8 -*-
class Warehouse::IncomingDeliveriesController < Warehouse::ApplicationController
  before_filter :find_incoming_delivery, only: [:show, :edit, :update]

  def index
    @incoming_deliveries_ongoing = IncomingDelivery.where(ongoing: true, warehouse_code: @warehouse_code).order("created_at DESC")
    @incoming_deliveries_past = IncomingDelivery.where(ongoing: false, warehouse_code: @warehouse_code).order("created_at DESC")
  end

  def show
  end
  
  def edit
    @product_categories = ProductCategory.where(warehouse_code: @warehouse_code).order("name ASC")
  end

  def new
    @incoming_delivery = IncomingDelivery.new
    @product_categories = ProductCategory.where(warehouse_code: @warehouse_code).order("name ASC")
    @incoming_delivery.incoming_delivery_products.build
    @customers = Array.new
  end

  def create
    @incoming_delivery = IncomingDelivery.new(incoming_delivery_params)
    @incoming_delivery.karnevalister.push current_user.karnevalist
    @incoming_delivery.warehouse_code = @warehouse_code
    if params[:finished]
      @incoming_delivery.ongoing = false
    else
      @incoming_delivery.ongoing = true
    end
    if @incoming_delivery.save && !@incoming_delivery.ongoing
      if params[:direct_selling] == "yes" && !params[:sektion_id].blank? && !params[:karnevalist_id].blank?
        order = Order.new(sektion_id: params[:sektion_id], karnevalist_id: params[:karnevalist_id], warehouse_code: @warehouse_code, finished_at: DateTime.now, status: "Levererad")
        order.save
        partial_delivery = order.partial_deliveries.new(seller_id: current_user.karnevalist.id)
        partial_delivery.save
        @incoming_delivery.incoming_delivery_products.each do |incoming_delivery|
          product = Product.find(incoming_delivery.product_id)
          order.order_products.create(product_id: product.id, amount: incoming_delivery.amount.to_i, delivered_amount: incoming_delivery.amount.to_i)
          partial_delivery.partial_delivery_products.create(product_id: product.id, amount: incoming_delivery.amount.to_i)
        end
        redirect_to order_path(order)
      else 
        @incoming_delivery.incoming_delivery_products.each do |incoming_delivery|
          product = Product.find(incoming_delivery.product_id)
          stand_by = product.stock_balance_stand_by
          if stand_by == 0
            stock_balance_not_ordered = product.stock_balance_not_ordered + incoming_delivery.amount.to_i
            product.update_attributes(:stock_balance_not_ordered => stock_balance_not_ordered)   
          elsif stand_by >= incoming_delivery.amount.to_i
            stock_balance_ordered = product.stock_balance_ordered + incoming_delivery.amount.to_i
            stand_by -= incoming_delivery.amount.to_i
            product.update_attributes(:stock_balance_ordered => stock_balance_ordered)
            product.update_attributes(:stock_balance_stand_by => stand_by)
            backorders = Backorder.where(product_id: product.id).order("id ASC")
            incoming_amount = incoming_delivery.amount.to_i
            backorders.each do |b|
              break if incoming_amount < b.amount
              WarehouseMailer.notify_delivery("it@lundakarnevalen.se", b.order.karnevalist.email, "Dina restnoterade varor finns i lager", b.order).deliver
              incoming_amount -= b.amount
              b.delete
            end
          else
            stock_balance_ordered = product.stock_balance_ordered + stand_by
            stock_balance_not_ordered = incoming_delivery.amount.to_i - stand_by
            product.update_attributes(:stock_balance_ordered => stock_balance_ordered)
            product.update_attributes(:stock_balance_not_ordered => stock_balance_not_ordered)
            product.update_attributes(:stock_balance_stand_by => 0)
            backorders = Backorder.where(product_id: product.id)
            backorders.each do |b|
              WarehouseMailer.notify_delivery("it@lundakarnevalen.se", b.order.karnevalist.email, "Dina restnoterade varor finns i lager", b.order).deliver
              b.delete
            end
          end
        end
        redirect_to incoming_delivery_path(@incoming_delivery)
      end
    else
      @product_categories = ProductCategory.where(warehouse_code: @warehouse_code).order("name ASC")
      @incoming_delivery.incoming_delivery_products.build
      render :new
    end
  end

  def update
    if params[:finished]
      @incoming_delivery.ongoing = false
    else
      @incoming_delivery.ongoing = true
    end
    if @incoming_delivery.update_attributes(incoming_delivery_params)
      if !@incoming_delivery.ongoing
        @incoming_delivery.incoming_delivery_products.each do |incoming_delivery|
          product = Product.find(incoming_delivery.product_id)
          stand_by = product.stock_balance_stand_by
          if stand_by == 0
            stock_balance_not_ordered = product.stock_balance_not_ordered + incoming_delivery.amount.to_i
            product.update_attributes(:stock_balance_not_ordered => stock_balance_not_ordered)   
          elsif stand_by >= incoming_delivery.amount.to_i
            stock_balance_ordered = product.stock_balance_ordered + incoming_delivery.amount.to_i
            stand_by -= incoming_delivery.amount.to_i
            product.update_attributes(:stock_balance_ordered => stock_balance_ordered)
            product.update_attributes(:stock_balance_stand_by => stand_by)
            backorders = Backorder.where(product_id: product.id).order("id ASC")
            incoming_amount = incoming_delivery.amount.to_i
            backorders.each do |b|
              break if incoming_amount < b.amount
              WarehouseMailer.notify_delivery("it@lundakarnevalen.se", b.order.karnevalist.email, "Dina restnoterade varor finns i lager", b.order).deliver
              incoming_amount -= b.amount
              b.delete
            end
          else
            stock_balance_ordered = product.stock_balance_ordered + stand_by
            stock_balance_not_ordered = incoming_delivery.amount.to_i - stand_by
            product.update_attributes(:stock_balance_ordered => stock_balance_ordered)
            product.update_attributes(:stock_balance_not_ordered => stock_balance_not_ordered)
            product.update_attributes(:stock_balance_stand_by => 0)
            backorders = Backorder.where(product_id: product.id)
            backorders.each do |b|
              WarehouseMailer.notify_delivery("it@lundakarnevalen.se", b.order.karnevalist.email, "Dina restnoterade varor finns i lager", b.order).deliver
              b.delete
            end
          end
        end
      end
      redirect_to incoming_deliveries_path
    else
      @product_categories = ProductCategory.where(warehouse_code: @warehouse_code).order("name ASC")
      render :edit
    end
  end

  def delete
  end

  private
    def find_incoming_delivery
      @incoming_delivery = IncomingDelivery.find(params[:id])
    end
    def incoming_delivery_params
      params.require(:incoming_delivery).permit(:invoice_nbr, :ongoing, :delivery_cost, incoming_delivery_products_attributes: [:id, :_destroy, :amount, :product_id])
    end
end
