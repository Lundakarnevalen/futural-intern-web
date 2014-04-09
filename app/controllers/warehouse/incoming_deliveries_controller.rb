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
    if @incoming_delivery.save
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
          else
            stock_balance_ordered = product.stock_balance_ordered + stand_by
            stock_balance_not_ordered = incoming_delivery.amount.to_i - stand_by
            product.update_attributes(:stock_balance_ordered => stock_balance_ordered)
            product.update_attributes(:stock_balance_not_ordered => stock_balance_not_ordered)
            product.update_attributes(:stock_balance_stand_by => 0)
          end
        end
      end
      redirect_to incoming_delivery_path(@incoming_delivery)
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
          else
            stock_balance_ordered = product.stock_balance_ordered + stand_by
            stock_balance_not_ordered = incoming_delivery.amount.to_i - stand_by
            product.update_attributes(:stock_balance_ordered => stock_balance_ordered)
            product.update_attributes(:stock_balance_not_ordered => stock_balance_not_ordered)
            product.update_attributes(:stock_balance_stand_by => 0)
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
