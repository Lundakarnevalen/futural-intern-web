class Warehouse::ProductsController < Warehouse::ApplicationController
  before_filter :find_product, only: [:show, :edit, :update]
  def index
    @products = Product.all
  end

  def show
  end

  def new
    @product = Product.new
  end

  def create
     product = Product.new(product_params)
    if product.save
      redirect_to warehouse_products_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @product.update_attributes(product_params)
      redirect_to warehouse_products_path
    else
      render :edit
    end
  end

  def destroy
    Product.destroy params[:id]
    redirect_to warehouse_products_path
  end

  def incoming_deliveries
    @products = Product.all
  end
  
  def update_multiple
    params['new_amount'].each do |product_id, new_amount|
      if !new_amount.blank?
        product = Product.where(:id => product_id).first
        stand_by = product.stock_balance_stand_by
        if stand_by == 0
          product.update_attributes(:stock_balance_not_ordered => new_amount)
        elsif stand_by >= new_amount.to_i
          stock_balance_ordered = product.stock_balance_ordered + new_amount.to_i
          stand_by -= new_amount.to_i
          product.update_attributes(:stock_balance_ordered => stock_balance_ordered)
          product.update_attributes(:stock_balance_stand_by => stand_by)
        else
          stock_balance_ordered = product.stock_balance_ordered + stand_by
          stock_balance_not_ordered = new_amount.to_i - stand_by
          product.update_attributes(:stock_balance_ordered => stock_balance_ordered)
          product.update_attributes(:stock_balance_not_ordered => stock_balance_not_ordered)
          product.update_attributes(:stock_balance_stand_by => 0)
        end  
      end
    end
    redirect_to incoming_deliveries_warehouse_products_path
  end

  private
    def find_product
      @product = Product.find(params[:id])
    end
    
    def product_params
      params.require(:product).permit!
    end
end
