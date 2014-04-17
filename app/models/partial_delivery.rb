# -*- encoding : utf-8 -*-
class PartialDelivery < ActiveRecord::Base
  belongs_to :order
  has_many :partial_delivery_products
  has_many :products, through: :partial_delivery_products
end
