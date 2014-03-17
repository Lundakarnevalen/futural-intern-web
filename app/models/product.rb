class Product < ActiveRecord::Base
  belongs_to :product_category
  has_and_belongs_to_many :orders
end
