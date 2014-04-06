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
    text "Kvitto från #{@warehouse}", :align => :center, :size => 18
    text "Ordernr #{@order.order_number},"
    text "Beställare: #{@order.karnevalist.fornamn} #{@order.karnevalist.efternamn}"
    text "Status: #{@order.status}"
    order_date = @order.order_date.strftime("%Y-%m-%d %H:%M")
    text "Beställningsdatum: #{order_date}"
    !@order.delivery_date.blank? ? collect_date = @order.delivery_date.strftime("%Y-%m-%d") : collect_date = ""
    text "Hämtdatum: #{collect_date}"
    product_number = 1
    products.each do |p|
      order_product = OrderProduct.where(:order_id => @order.id, :product_id => p.id).first
      text "Produkt #{product_number}: #{p.name}, #{order_product.amount} #{p.unit}"
      product_number += 1
    end
    text "Totalpris: #{@order.total_sum} kr"

    image @image_path, :position => :center, :scale => 0.7

    
  end
end
