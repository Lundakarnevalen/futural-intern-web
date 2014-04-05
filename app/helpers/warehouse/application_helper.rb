 module Warehouse::ApplicationHelper
  def icon(name)
    content_tag(:i, nil, class: "glyphicon glyphicon-#{name}")
  end

  def form_prefix
    @warehouse_code == 0 ? :fabriken : :fest
  end
  # orders
  def calendar_orders_path
    @warehouse_code == 0 ? calendar_fabriken_orders_path : calendar_fest_orders_path
  end

  def orders_path
    @warehouse_code == 0 ? fabriken_orders_path : fest_orders_path
  end

  def new_order_path
    @warehouse_code == 0 ? new_fabriken_order_path : new_fest_order_path
  end

  def list_orders_path
    @warehouse_code == 0 ? list_fabriken_orders_path : list_fest_orders_path
  end

  #deliveries
  def incoming_deliveries_path
    @warehouse_code == 0 ? fabriken_incoming_deliveries_path : fest_incoming_deliveries_path
  end

  def new_incoming_delivery_path
    @warehouse_code == 0 ? new_fabriken_incoming_delivery_path : new_fest_incoming_delivery_path
  end
  # products
  def weekly_overview_products_path
    @warehouse_code == 0 ? weekly_overview_fabriken_products_path : weekly_overview_fest_products_path
  end

  def products_path
    @warehouse_code == 0 ? fabriken_products_path : fest_products_path
  end

  def inactivate_product_path(p)
    @warehouse_code == 0 ? inactivate_fabriken_product_path(p) : inactivate_fest_product_path(p)
  end

  def new_product_path
    @warehouse_code == 0 ? new_fabriken_product_path : new_fest_product_path
  end

  def product_categories_path
    @warehouse_code == 0 ? fabriken_product_categories_path : fest_product_categories_path
  end

  def new_product_category_path
    @warehouse_code == 0 ? new_fabriken_product_category_path : new_fest_product_category_path
  end

  def edit_product_path(p)
    @warehouse_code == 0 ? edit_fabriken_product_path(p) : edit_fest_product_path(p)
  end


end
