# -*- encoding : utf-8 -*-
class Blockorder < ActiveRecord::Base
  belongs_to :sektion
  has_many :blockorder_products
  has_many :products, through: :blockorder_products
  validates :sektion, presence: true, uniqueness: true
  
  accepts_nested_attributes_for :blockorder_products, :reject_if => proc { |a| a['amount'].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :products
  
  HUMANIZED_ATTRIBUTES = {
    :sektion => "Sektionen",
  }

  def self.human_attribute_name(attr, options = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
end
