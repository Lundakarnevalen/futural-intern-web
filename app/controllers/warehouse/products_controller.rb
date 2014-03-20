class Warehouse::ProductsController < Warehouse::ApplicationController
  before_filter :find_order, only: [:show, :update]
  def index
    @orders = Product.all
  end

  def show
  end

  def new
    @order = Product.new
  end

  def create
     product = Product.new(order_params)
    if product.save
      redirect_to product
    else
      render :new
    end
  end

  def update
  end

  def delete
  end

  private
    def find_order
      @order = Product.find(params[:id])
    end
    def order_params
      params.require(:product).permit!
    end
end
