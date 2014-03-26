class Product < ActiveRecord::Base
  belongs_to :product_category
  has_many :order_products
  has_many :orders, through: :order_products

  def product_info(order_id)
    return self.order_products.find_by_order_id(order_id)
  end
end
