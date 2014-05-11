# -*- encoding : utf-8 -*-
class Product < ActiveRecord::Base
  belongs_to :product_category
  has_many :order_products
  has_many :orders, through: :order_products
  has_many :blockorder_products
  has_many :blockorders, through: :blockorder_products
  has_many :incoming_delivery_products
  has_many :incoming_deliveries, through: :incoming_delivery_products
  has_many :partial_delivery_products
  has_many :partial_deliveries, through: :partial_delivery_products
  has_many :backorders
  
  before_save :purchase_price
  before_save :sale_price

  validates :product_category_id, presence: true
  validates :name, presence: true
  validates :unit, presence: true
  validates :supplier, presence: true
  validates :purchase_price, numericality: true
  validates :sale_price, numericality: true

  HUMANIZED_ATTRIBUTES = {
    :product_category_id => "Kategori",
    :name => "Namn",
    :unit => "Enhet",
    :supplier => "Leverantör",
    :purchase_price => "Inköpspris",
    :sale_price => "Försäljningspris"
  }

  def self.human_attribute_name(attr, options = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
  
  def purchase_price=(purchase_price)
    self[:purchase_price] = purchase_price.gsub(/\,/, ".").to_f unless purchase_price.blank?
  end
  
  def sale_price=(sale_price)
    self[:sale_price] = sale_price.gsub(/\,/, ".").to_f unless sale_price.blank?
  end

  def amount(order_id)
    return self.order_products.find_by_order_id(order_id).amount
  end
  
  def delivered_amount(order_id)
    return self.order_products.find_by_order_id(order_id).delivered_amount
  end

  def new_amount(incoming_delivery_id)
    return self.incoming_delivery_products.find_by_incoming_delivery_id(incoming_delivery_id).amount
  end

  def partial_delivery_amount(partial_delivery_id)
    return self.partial_delivery_products.find_by_partial_delivery_id(partial_delivery_id).amount
  end

  def sektion_amount(sektion_id, orders)
    amount = 0
    orders.each do |o|
      order_product = o.order_products.find_by_product_id(self.id)
      if !order_product.blank?
        amount += order_product.delivered_amount
      end
    end
    return amount
  end
  
  def blockorder_amount(sektion_id)
    blockorder = Blockorder.find_by_sektion_id(sektion_id)
    if blockorder.blank?
      return 0
    else
      bp = blockorder.blockorder_products.find_by_product_id(self.id)
      return !bp.blank? ? bp.amount : 0
    end
  end

  def total_price(amount)
    return amount*self.sale_price
  end
  
  def total_purchase_price(amount)
    return amount*self.purchase_price
  end
end
