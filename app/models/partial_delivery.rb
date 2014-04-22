# -*- encoding : utf-8 -*-
class PartialDelivery < ActiveRecord::Base
  belongs_to :order
  has_many :partial_delivery_products
  has_many :products, through: :partial_delivery_products
  
  accepts_nested_attributes_for :partial_delivery_products, :reject_if => proc { |a| a['amount'].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :products
end
