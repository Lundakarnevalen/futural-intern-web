class Product < ActiveRecord::Base
  belongs_to :product_category
  has_many :orders, :through => :orders_products
  has_many :orders_products
end
