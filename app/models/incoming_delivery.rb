class IncomingDelivery < ActiveRecord::Base
  has_and_belongs_to_many :karnevalister
  has_many :incoming_delivery_products
  has_many :products, through: :incoming_delivery_products
  validates :karnevalist, presence: true
  
  accepts_nested_attributes_for :incoming_delivery_products, :reject_if => proc { |a| a['amount'].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :products
end
