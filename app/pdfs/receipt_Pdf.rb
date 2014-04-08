class ReceiptPdf < Prawn::Document

  def initialize(order, view, warehouse_code)
    super()
    @order = order
    products = @order.products
    if warehouse_code == 0
      @warehouse = "Fabriken"
      @image_path = "app/pdfs/fabriken.png"
    else
      @warehouse = "Festmästeriet"
      @image_path = "app/pdfs/festmasteriet.png"
    end
    image "app/pdfs/logo.png", :at => [430, cursor], :width => 100, :height => 100
    pad_top(25) do
      text "Kvitto från #{@warehouse}", :align => :center, :size => 18
      text "Order nr: #{@order.id}"
      text "Beställare: #{@order.karnevalist.fornamn} #{@order.karnevalist.efternamn}"
      text "Status: #{@order.status}"
      order_date = @order.order_date.strftime("%Y-%m-%d %H:%M")
      text "Beställningsdatum: #{order_date}"
      !@order.delivery_date.blank? ? collect_date = @order.delivery_date.strftime("%Y-%m-%d") : collect_date = ""
      text "Hämtdatum: #{collect_date}"
      product_number = 1
      table_data = Array.new
      titles = ["Vara","Mängd","Styckpris","Totalt pris"]
      table_data.push(titles)
      products.each do |p|
        amount = p.amount(@order.id)
        total_price = p.total_price(amount)
        order_product = OrderProduct.where(:order_id => @order.id, :product_id => p.id).first
        data = ["#{p.name}", "#{order_product.amount} #{p.unit}","#{p.sale_price}", "#{total_price} kr"]
        table_data.push(data)
        product_number += 1
      end
      pad_top(10) do
        table(table_data, :width => 500, :cell_style => { :inline_format => true })
      end
      pad_top(10) do
        text "Pris för hela ordern: #{@order.total_sum} kr"
      end
    end

    image @image_path, :at => [50, 500], :scale => 0.7

    
  end
end
