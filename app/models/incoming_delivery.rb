# -*- encoding : utf-8 -*-
class IncomingDelivery < ActiveRecord::Base
  has_and_belongs_to_many :karnevalister
  has_many :incoming_delivery_products
  has_many :products, through: :incoming_delivery_products
  validates :karnevalister, presence: true
  validates :invoice_nbr, presence: true, uniqueness: true

  before_save :delivery_cost
  
  accepts_nested_attributes_for :incoming_delivery_products, :reject_if => proc { |a| a['amount'].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :products
  
  HUMANIZED_ATTRIBUTES = {
    :invoice_nbr => "Fakturanummer"
  }

  def self.human_attribute_name(attr, options = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
  
  def delivery_cost=(delivery_cost)
    self[:delivery_cost] = delivery_cost.gsub(/\,/, ".").to_f unless delivery_cost.blank?
  end

  def self.find_incoming_deliveries_in_date date, warehouse_code
    incoming_deliveries = IncomingDelivery.where("created_at >= ?", date).where("created_at <= ?", date + 1.day).where(warehouse_code: warehouse_code)
    return incoming_deliveries
  end

  def self.find_incoming_deliveries_in_week week, warehouse_code
    incoming_deliveries = IncomingDelivery.where("created_at >= ? AND created_at <= ? AND warehouse_code = ?", week[:day_1], week[:day_7], warehouse_code)
    return incoming_deliveries
  end

end
