class Warehouse::ProductsController < Warehouse::ApplicationController
  before_filter :find_product, only: [:show, :update]
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
    find_product
  end

  def update
    find_product
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

  private
    def find_product
      @product = Product.find(params[:id])
    end
    def product_params
      params.require(:product).permit!
    end
end
