class Warehouse::ProductsController < Warehouse::ApplicationController
  before_filter :find_product, only: [:show, :edit, :update, :inactivate, :activate]
  def index
    @products_active = Product.where(warehouse_code: @warehouse_code, active: true).order("name DESC")
    @products_inactive = Product.where(warehouse_code: @warehouse_code, active: false).order("name DESC")
    @product_categories = ProductCategory.where(warehouse_code: @warehouse_code)
  end

  def show
  end

  def new
    @product = Product.new
    @product_categories = ProductCategory.where(warehouse_code: @warehouse_code)
  end

  def create
    product = Product.new(product_params)
    product.active = true
    product.warehouse_code = @warehouse_code
    if product.save
      redirect_to products_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @product.update_attributes(product_params)
      redirect_to products_path
    else
      render :edit
    end
  end

  def destroy
    Product.destroy params[:id]
    redirect_to products_path
  end

  def incoming_deliveries
    @products = Product.where(warehouse_code: @warehouse_code)
  end

  def weekly_overview
    @products = Product.where(warehouse_code: @warehouse_code)
  end
  
  def inactivate
    @product.update_attributes(active: false)
    redirect_to products_path
  end

  def activate
    @product.update_attributes(active: true)
    redirect_to products_path
  end

  private
    def find_product
      @product = Product.find(params[:id])
    end
    
    def product_params
      params.require(:product).permit!
    end
end
