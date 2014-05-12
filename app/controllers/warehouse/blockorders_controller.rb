# -*- encoding : utf-8 -*-
class Warehouse::BlockordersController < Warehouse::ApplicationController
  before_filter :find_blockorder, only: [:show, :edit, :update]

  def index
    @blockordrar = Blockorder.where(warehouse_code: @warehouse_code).order("sektion_id ASC")
  end

  def show
    rendet :edit
  end
  
  def edit
    @product_categories = ProductCategory.where(warehouse_code: @warehouse_code).order("name ASC")
  end

  def new
    @blockorder = Blockorder.new
    @product_categories = ProductCategory.where(warehouse_code: @warehouse_code).order("name ASC")
    @blockorder.blockorder_products.build
  end

  def create
    @blockorder = Blockorder.new(blockorder_params)
    @blockorder.warehouse_code = @warehouse_code
    if @blockorder.save
      redirect_to blockorders_path
    else
      @product_categories = ProductCategory.where(warehouse_code: @warehouse_code).order("name ASC")
      @blockorder.blockorder_products.build
      render :new
    end
  end

  def update
    if @blockorder.update_attributes(blockorder_params)
      redirect_to blockorders_path
    else
      @product_categories = ProductCategory.where(warehouse_code: @warehouse_code).order("name ASC")
      render :edit
    end
  end

  def delete
  end

  private
    def find_blockorder
      @blockorder = Blockorder.find(params[:id])
    end
    def blockorder_params
      params.require(:blockorder).permit(:sektion_id, blockorder_products_attributes: [:id, :_destroy, :amount, :product_id])
    end
end
