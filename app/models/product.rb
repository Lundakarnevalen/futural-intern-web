class Product < ActiveRecord::Base
  belongs_to :product_category
  has_many :order_products
  has_many :orders, through: :order_products
  has_many :incoming_delivery_products
  has_many :incoming_deliveries, through: :incoming_delivery_products

  def amount(order_id)
    return self.order_products.find_by_order_id(order_id).amount
  end

  def new_amount(incoming_delivery_id)
    return self.incoming_delivery_products.find_by_incoming_delivery_id(incoming_delivery_id).amount
  end

  def total_price(amount)
    return amount*self.sale_price
  end
end
