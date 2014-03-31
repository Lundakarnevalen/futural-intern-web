class ReceiptPdf < Prawn::Document

  def initialize(order, view)
    super()
    @order = order
    text "Order #{@order.id},"
    text "Status #{@order.status}"
    text "Beställningsdatum: #{@order.order_date}"
    text "Hämtdatum: #{@order.delivery_date}"
    text "Totalpris #{@order.total_sum}"
  end
end
