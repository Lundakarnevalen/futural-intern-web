# -*- encoding : utf-8 -*-
class Warehouse::PartialDeliveriesController < Warehouse::ApplicationController
  before_filter :find_partial_delivery, only: [:show]

  def show
  end
  
  def new
    @partial_delivery = PartialDelivery.new
    @product_categories = ProductCategory.where(warehouse_code: @warehouse_code).order("name ASC")
    @partial_delivery.partial_delivery_products.build
  end

  def create
    @partial_delivery = PartialDelivery.new(partial_delivery_params)
    @partial_delivery.seller_id = current_user.karnevalist.id
    if @partial_delivery.save
      order = Order.find(@partial_delivery.order_id)
      order.status = "Dellevererad"
      order.save
      @partial_delivery.partial_delivery_products.each do |partial_product|
        product = Product.find(partial_product.product_id)
        in_stock = product.stock_balance_ordered
        if in_stock >= partial_product.amount.to_i
          in_stock -= partial_product.amount.to_i
          product.update_attributes(:stock_balance_ordered => in_stock)
          order_product = product.order_products.find_by_order_id(order.id)
          delivered_amount = order_product.delivered_amount + partial_product.amount.to_i
          order_product.update_attributes(:delivered_amount => delivered_amount)
        end
      end
      redirect_to order_path(params[:partial_delivery][:order_id])
    else
      @product_categories = ProductCategory.where(warehouse_code: @warehouse_code).order("name ASC")
      @partial_delivery.partial_delivery_products.build
      render :new
    end
  end

  private
    def find_partial_delivery
      @partial_delivery = PartialDelivery.find(params[:id])
    end
    def partial_delivery_params
      params.require(:partial_delivery).permit(:seller_id, :order_id, partial_delivery_products_attributes: [:id, :_destroy, :amount, :product_id])
    end
end
