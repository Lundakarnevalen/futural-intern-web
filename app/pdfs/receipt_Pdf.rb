class ReceiptPdf < Prawn::Document

  def initialize(order, view, warehouse_code)
    super()
    @order = order
    if warehouse_code == 0
      @warehouse = "Fabriken"
      @image_path = "app/pdfs/fabriken.png"
    else
      @warehouse = "Festmästeriet"
      @image_path = "app/pdfs/festmasteriet.png"
    end
    image "app/pdfs/logo.png", :at => [430, cursor], :width => 100, :height => 100
    text "Kvitto från #{@warehouse}", :align => :center, :size => 18
    text "Order nr #{@order.id},"
    text "Beställare: #{@order.karnevalist.fornamn} #{@order.karnevalist.efternamn}"
    text "Status: #{@order.status}"
    text "Beställningsdatum: #{@order.order_date}"
    text "Hämtdatum: #{@order.delivery_date}"
    text "Totalpris: #{@order.total_sum} kr"

    if warehouse_code == 0
      image @image_path, :position => :center, :scale => 0.7
    end
  end
end
