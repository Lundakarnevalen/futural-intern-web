class Product < ActiveRecord::Base
  belongs_to :product_category
  has_many :order_products
  has_many :orders, through: :order_products

  def amount(order_id)
    return self.order_products.find_by_order_id(order_id).amount
  end

  def total_price(amount, unit_price)
    return amount*unit_price
  end
end
