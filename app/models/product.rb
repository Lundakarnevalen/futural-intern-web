class Product < ActiveRecord::Base
  belongs_to :product_category
  has_many :orders, :through => :order_products
end
