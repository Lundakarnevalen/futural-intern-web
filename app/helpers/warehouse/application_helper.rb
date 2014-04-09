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

  def order_path(o, format = :html)
    @warehouse_code == 0 ? fabriken_order_path(o, format) : fest_order_path(o, format)
  end

  def orders_path
    @warehouse_code == 0 ? fabriken_orders_path : fest_orders_path
  end

  def new_order_path
    @warehouse_code == 0 ? new_fabriken_order_path : new_fest_order_path
  end
  
  def confirm_order_path(o)
    @warehouse_code == 0 ? confirm_fabriken_order_path(o) : confirm_fest_order_path(o)
  end
  
  def confirm_put_order_path(o)
    @warehouse_code == 0 ? confirm_put_fabriken_order_path(o) : confirm_put_fest_order_path(o)
  end

  def list_orders_path
    @warehouse_code == 0 ? list_fabriken_orders_path : list_fest_orders_path
  end

  def return_products_order_path
    @warehouse_code == 0 ? return_products_fabriken_order_path : return_products_fest_order_path
  end
  
  def direct_selling_orders_path
    @warehouse_code == 0 ? direct_selling_fabriken_orders_path : direct_selling_fest_orders_path
  end

  def direct_selling_post_orders_path
    @warehouse_code == 0 ? direct_selling_post_fabriken_orders_path : direct_selling_post_fest_orders_path
  end
  
  def update_customers_orders_path
    @warehouse_code == 0 ? update_customers_fabriken_orders_path : update_customers_fest_orders_path
  end

  #deliveries
  def incoming_deliveries_path
    @warehouse_code == 0 ? fabriken_incoming_deliveries_path : fest_incoming_deliveries_path
  end
  
  def incoming_delivery_path(i, format = :html)
    @warehouse_code == 0 ? fabriken_incoming_delivery_path(i, format) : fest_incoming_delivery_path(i, format)
  end

  def new_incoming_delivery_path
    @warehouse_code == 0 ? new_fabriken_incoming_delivery_path : new_fest_incoming_delivery_path
  end
  
  def edit_incoming_delivery_path(i)
    @warehouse_code == 0 ? edit_fabriken_incoming_delivery_path(i) : edit_fest_incoming_delivery_path(i)
  end
  # products
  def weekly_overview_products_path
    @warehouse_code == 0 ? weekly_overview_fabriken_products_path : weekly_overview_fest_products_path
  end

  def products_path
    @warehouse_code == 0 ? fabriken_products_path : fest_products_path
  end

  def product_path(p, format = :html)
    @warehouse_code == 0 ? fabriken_product_path(p, format) : fest_product_path(p, format)
  end

  def edit_product_path(p)
    @warehouse_code == 0 ? edit_fabriken_product_path(p) : edit_fest_product_path(p)
  end
  
  def activate_product_path(p)
    @warehouse_code == 0 ? activate_fabriken_product_path(p) : activate_fest_product_path(p)
  end

  def inactivate_product_path(p)
    @warehouse_code == 0 ? inactivate_fabriken_product_path(p) : inactivate_fest_product_path(p)
  end

  def new_product_path
    @warehouse_code == 0 ? new_fabriken_product_path : new_fest_product_path
  end

  # categories
  def product_categories_path
    @warehouse_code == 0 ? fabriken_product_categories_path : fest_product_categories_path
  end

  def product_category_path(p, format = :html)
    @warehouse_code == 0 ? fabriken_product_category_path(p, format) : fest_product_category_path(p, format)
  end

  def new_product_category_path
    @warehouse_code == 0 ? new_fabriken_product_category_path : new_fest_product_category_path
  end

  def edit_product_category_path(p)
    @warehouse_code == 0 ? edit_fabriken_product_category_path(p) : edit_fest_product_category_path(p)
  end

end
