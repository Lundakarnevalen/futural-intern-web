class Warehouse::ProductCategoriesController < Warehouse::ApplicationController
  before_filter :find_product_category, only: [:show, :edit, :update]
  def index
    @product_categories = ProductCategory.all
  end

  def show
    render :edit
  end

  def new
    @product_category = ProductCategory.new
  end

  def create
     product_category = ProductCategory.new(product_category_params)
    if product_category.save
      redirect_to warehouse_product_categories_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @product_category.update_attributes(product_category_params)
      redirect_to warehouse_product_categories_path
    else
      render :edit
    end
  end

  def destroy
    ProductCategory.destroy params[:id]
    redirect_to warehouse_product_categories_path
  end

  private
    def find_product_category
      @product_category = ProductCategory.find(params[:id])
    end
    def product_category_params
      params.require(:product_category).permit!
    end
end
