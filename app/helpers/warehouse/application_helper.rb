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

  def generate_pdf(order, view, warehouse_code)
    pdf = Prawn::Document.new do
    products = order.products
    if warehouse_code == 0
      @warehouse = "Fabriken"
      @image_path = "app/assets/images/pdf/fabriken.png"
    else
      @warehouse = "Festmästeriet"
      @image_path = "app/assets/images/pdf/festmasteriet.png"
    end
    image @image_path, :at => [0, cursor], :width => 100, :height => 100
    image "app/assets/images/pdf/logo.png", :at => [430, cursor], :width => 100, :height => 100
    pad_top(25) do
      text "Kvitto från #{@warehouse}", :align => :center, :size => 18
      pad_top(55) do
        text "Ordernr: #{order.id}"
        text "Beställare: #{order.karnevalist.fornamn} #{order.karnevalist.efternamn}"
        text "Sektion: #{order.sektion.name}"
        text "Status: #{order.status}"
        order_date = order.order_date.strftime("%Y-%m-%d %H:%M")
        text "Beställningsdatum: #{order_date}"
        !order.delivery_date.blank? ? collect_date = order.delivery_date.strftime("%Y-%m-%d") : collect_date = ""
        text "Hämtdatum: #{collect_date}"
        product_number = 1
        table_data = Array.new
        titles = ["Vara","Mängd","Styckpris","Totalt pris"]
        table_data.push(titles)
        products.each do |p|
          amount = p.amount(order.id)
          total_price = ActionController::Base.helpers.number_to_currency(p.total_price(amount))
          sale_price = ActionController::Base.helpers.number_to_currency(p.sale_price)
          order_product = OrderProduct.where(:order_id => order.id, :product_id => p.id).first
          data = ["#{p.name}", "#{order_product.amount} #{p.unit}","#{sale_price}", "#{total_price}"]
          table_data.push(data)
          product_number += 1
        end
        pad_top(10) do
          table(table_data, :width => 500, :cell_style => { :inline_format => true })
        end
        pad_top(10) do
          text "Pris för hela ordern: #{ActionController::Base.helpers.number_to_currency(order.total_sum)}"
        end
      end
    end

    

    end
  end

end
