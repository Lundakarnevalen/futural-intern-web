# -*- encoding : utf-8 -*-
class Warehouse::PartialDeliveriesController < Warehouse::ApplicationController
  before_filter :find_partial_delivery, only: [:show, :edit, :update]

  def index
    @partial_deliveries_ongoing = PartialDelivery.where(ongoing: true, warehouse_code: @warehouse_code).order("created_at DESC")
    @partial_deliveries_past = PartialDelivery.where(ongoing: false, warehouse_code: @warehouse_code).order("created_at DESC")
  end

  def show
  end
  
  def edit
    @product_categories = ProductCategory.where(warehouse_code: @warehouse_code).order("name ASC")
  end

  def new
    @partial_delivery = PartialDelivery.new
    @product_categories = ProductCategory.where(warehouse_code: @warehouse_code).order("name ASC")
    @partial_delivery.partial_delivery_products.build
  end

  def create
    @partial_delivery = PartialDelivery.new(partial_delivery_params)
    @partial_delivery.karnevalister.push current_user.karnevalist
    @partial_delivery.warehouse_code = @warehouse_code
    if params[:finished]
      @partial_delivery.ongoing = false
    else
      @partial_delivery.ongoing = true
    end
    if @partial_delivery.save
      if !@partial_delivery.ongoing
        @partial_delivery.partial_delivery_products.each do |partial_delivery|
          product = Product.find(partial_delivery.product_id)
          stand_by = product.stock_balance_stand_by
          if stand_by == 0
            stock_balance_not_ordered = product.stock_balance_not_ordered + partial_delivery.amount.to_i
            product.update_attributes(:stock_balance_not_ordered => stock_balance_not_ordered)   
          elsif stand_by >= partial_delivery.amount.to_i
            stock_balance_ordered = product.stock_balance_ordered + partial_delivery.amount.to_i
            stand_by -= partial_delivery.amount.to_i
            product.update_attributes(:stock_balance_ordered => stock_balance_ordered)
            product.update_attributes(:stock_balance_stand_by => stand_by)
          else
            stock_balance_ordered = product.stock_balance_ordered + stand_by
            stock_balance_not_ordered = partial_delivery.amount.to_i - stand_by
            product.update_attributes(:stock_balance_ordered => stock_balance_ordered)
            product.update_attributes(:stock_balance_not_ordered => stock_balance_not_ordered)
            product.update_attributes(:stock_balance_stand_by => 0)
          end
        end
      end
      redirect_to partial_delivery_path(@partial_delivery)
    else
      @product_categories = ProductCategory.where(warehouse_code: @warehouse_code).order("name ASC")
      @partial_delivery.partial_delivery_products.build
      render :new
    end
  end

  def update
    if params[:finished]
      @partial_delivery.ongoing = false
    else
      @partial_delivery.ongoing = true
    end
    if @partial_delivery.update_attributes(partial_delivery_params)
      if !@partial_delivery.ongoing
        @partial_delivery.partial_delivery_products.each do |partial_delivery|
          product = Product.find(partial_delivery.product_id)
          stand_by = product.stock_balance_stand_by
          if stand_by == 0
            stock_balance_not_ordered = product.stock_balance_not_ordered + partial_delivery.amount.to_i
            product.update_attributes(:stock_balance_not_ordered => stock_balance_not_ordered)   
          elsif stand_by >= partial_delivery.amount.to_i
            stock_balance_ordered = product.stock_balance_ordered + partial_delivery.amount.to_i
            stand_by -= partial_delivery.amount.to_i
            product.update_attributes(:stock_balance_ordered => stock_balance_ordered)
            product.update_attributes(:stock_balance_stand_by => stand_by)
          else
            stock_balance_ordered = product.stock_balance_ordered + stand_by
            stock_balance_not_ordered = partial_delivery.amount.to_i - stand_by
            product.update_attributes(:stock_balance_ordered => stock_balance_ordered)
            product.update_attributes(:stock_balance_not_ordered => stock_balance_not_ordered)
            product.update_attributes(:stock_balance_stand_by => 0)
          end
        end
      end
      redirect_to partial_deliveries_path
    else
      @product_categories = ProductCategory.where(warehouse_code: @warehouse_code).order("name ASC")
      render :edit
    end
  end

  def delete
  end

  private
    def find_partial_delivery
      @partial_delivery = PartialDelivery.find(params[:id])
    end
    def partial_delivery_params
      params.require(:partial_delivery).permit(:seller_id, :order_id, partial_delivery_products_attributes: [:id, :_destroy, :amount, :product_id])
    end
end
