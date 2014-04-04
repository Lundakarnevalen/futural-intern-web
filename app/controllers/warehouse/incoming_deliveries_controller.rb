class Warehouse::IncomingDeliveriesController < Warehouse::ApplicationController
  before_filter :find_incoming_delivery, only: [:show, :edit, :update]

  def index
    @incoming_deliveries_ongoing = IncomingDelivery.where(ongoing: true, warehouse_code: @warehouse_code).order("created_at DESC")
    @incoming_deliveries_past = IncomingDelivery.where(ongoing: false, warehouse_code: @warehouse_code).order("created_at DESC")
  end

  def show
  end
  
  def edit
    @products = Product.where(active true, warehouse_code: @warehouse_code).order("name DESC")
  end

  def new
    @incoming_delivery = IncomingDelivery.new
    @products = Product.where(active true, warehouse_code: @warehouse_code).order("name DESC")
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
      #params['new_amount'].each do |product_id, new_amount|
      #if !new_amount.blank?
       # product = Product.where(:id => product_id).first
        #stand_by = product.stock_balance_stand_by
        #if stand_by == 0
         # product.update_attributes(:stock_balance_not_ordered => new_amount)
        #elsif stand_by >= new_amount.to_i
         # stock_balance_ordered = product.stock_balance_ordered + new_amount.to_i
          #stand_by -= new_amount.to_i
          #product.update_attributes(:stock_balance_ordered => stock_balance_ordered)
         # product.update_attributes(:stock_balance_stand_by => stand_by)
        #else
          #stock_balance_ordered = product.stock_balance_ordered + stand_by
          #stock_balance_not_ordered = new_amount.to_i - stand_by
          #product.update_attributes(:stock_balance_ordered => stock_balance_ordered)
          #product.update_attributes(:stock_balance_not_ordered => stock_balance_not_ordered)
         # product.update_attributes(:stock_balance_stand_by => 0)
        #end  
     # end
    #end
      redirect_to incoming_deliveries_path
    else
      @products = Product.where(active true, warehouse_code: @warehouse_code).order("name DESC")
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
      redirect_to incoming_deliveries_path
    else
      @products = Product.where(active true, warehouse_code: @warehouse_code).order("name DESC")
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
      params.require(:incoming_delivery).permit(:invoice_nbr, :ongoing, incoming_delivery_products_attributes: [:id, :_destroy, :amount, :product_id])
    end
end
