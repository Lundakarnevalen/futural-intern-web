# -*- encoding : utf-8 -*-
class Warehouse::ProductCategoriesController < Warehouse::ApplicationController
  before_filter :find_product_category, only: [:show, :edit, :update, :destroy]

  def index
    @product_categories = ProductCategory.where(warehouse_code: @warehouse_code)
  end

  def show
    render :edit
  end

  def new
    @product_category = ProductCategory.new
  end

  def create
    @product_category = ProductCategory.new(product_category_params)
    @product_category.warehouse_code = @warehouse_code
    if @product_category.save
      redirect_to product_categories_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @product_category.update_attributes(product_category_params)
      redirect_to product_categories_path
    else
      render :edit
    end
  end

  def destroy
    begin
      @product_category.destroy
    rescue ActiveRecord::DeleteRestrictionError => e
      @product_category.errors.add(:base, e)
      flash[:error] = "Kan inte ta bort en kategori som innehåller produkter"
    ensure
      redirect_to product_categories_path
    end
  end

  private
    def find_product_category
      @product_category = ProductCategory.find(params[:id])
    end
    def product_category_params
      params.require(:product_category).permit!
    end
end
