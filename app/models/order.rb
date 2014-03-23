class Order < ActiveRecord::Base
  belongs_to :karnevalist
  has_many :products, :through :order_products
end
