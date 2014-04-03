class Warehouse::ProductsController < Warehouse::ApplicationController
  before_filter :find_product, only: [:show, :edit, :update]
  def index
    @products_active = Product.find_all_by_active(true)
    @products_inactive = Product.find_all_by_active(false)
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
  
  def inactivate
    find_product
    @product.update_attributes(active: false)
    redirect_to warehouse_products_path
  end

  def activate
    find_product
    @product.update_attributes(active: true)
    redirect_to warehouse_products_path
  end

  private
    def find_product
      @product = Product.find(params[:id])
    end
    
    def product_params
      params.require(:product).permit!
    end
end
