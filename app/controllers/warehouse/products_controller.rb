# -*- encoding : utf-8 -*-
class Warehouse::ProductsController < Warehouse::ApplicationController
  before_filter :find_product, only: [:show, :edit, :update, :inactivate, :activate]
  def index
    @product_categories = ProductCategory.where(warehouse_code: @warehouse_code).order("name ASC")
  end

  def show
  end

  def new
    @product = Product.new
    @product_categories = ProductCategory.where(warehouse_code: @warehouse_code)
  end

  def create
    @product = Product.new(product_params)
    @product.active = true
    @product.warehouse_code = @warehouse_code
    if @product.save
      redirect_to products_path
    else
      @product_categories = ProductCategory.where(warehouse_code: @warehouse_code)
      render :new
    end
  end

  def edit
    @product_categories = ProductCategory.where(warehouse_code: @warehouse_code)
  end

  def update
    if @product.update_attributes(product_params)
      redirect_to products_path
    else
      @product_categories = ProductCategory.where(warehouse_code: @warehouse_code)
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
    @orders = Order.where("status IS NOT NULL AND finished_at IS NOT NULL AND warehouse_code = ?", @warehouse_code)
    @incoming_deliveries = IncomingDelivery.where(warehouse_code: @warehouse_code)
    first_week_number = 15
    last_week_number = 21
    date_first_day = DateTime.new(2014,4,7,0,0,0,'+1')
    @weeks = calculate_weeks(date_first_day, first_week_number, last_week_number)
    if @warehouse_code == 0
      @weeks = Kaminari.paginate_array(@weeks).page(params[:page]).per(2)
    end
  end

  def daily_overview
    @orders = Order.where("status IS NOT NULL AND finished_at IS NOT NULL AND warehouse_code = ?", @warehouse_code)
    @incoming_deliveries = IncomingDelivery.where(warehouse_code: @warehouse_code)
    @dates = Order.find_all_dates(@warehouse_code)
  end

  def calculate_weeks date_first_day, first_week_number, last_week_number
    weeks = Array.new
    for i in first_week_number..last_week_number
      weeks.push({day_1: date_first_day, day_7: date_first_day + 7.days - 1.seconds, week: i})
      date_first_day = date_first_day + 7.days
    end
    return weeks
  end
  
  def inactivate
    @product.update_attributes(active: false)
    redirect_to products_path
  end

  def activate
    @product.update_attributes(active: true)
    redirect_to products_path
  end

  def inventory
    @product_categories = ProductCategory.where(warehouse_code: @warehouse_code).order("name ASC")
    @inventories = Inventory.where(warehouse_code: @warehouse_code).order("id DESC")
  end
  
  def update_inventory
    params['stock_balance'].each do |product_id, stock_balance|
      if !stock_balance.blank?
        product = Product.find(product_id)
        product.update_attributes(stock_balance_not_ordered: stock_balance)
      end
    end
    Inventory.create(inventory_taker_id: current_user.karnevalist.id, warehouse_code: @warehouse_code)
    redirect_to inventory_products_path
  end

  def sektion_summary
    if params[:sektion_id]
      if @warehouse_code == 0
        @product_categories = ProductCategory.where(warehouse_code: @warehouse_code).order("name ASC").page(params[:page]).per(2)
      else
        @product_categories = ProductCategory.where(warehouse_code: @warehouse_code).order("name ASC")
      end
      @sektion = Sektion.find(params[:sektion_id])
      @orders = Order.where(sektion_id: params[:sektion_id], warehouse_code: @warehouse_code)
    end
  end

  private
    def find_product
      @product = Product.find(params[:id])
    end
    
    def product_params
      params.require(:product).permit!
    end
end
