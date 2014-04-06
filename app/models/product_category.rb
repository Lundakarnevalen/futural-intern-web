class ProductCategory < ActiveRecord::Base
  has_many :products
  validates :name, presence: true, uniqueness: true
  
  HUMANIZED_ATTRIBUTES = {
    :name => "Namn"
  }

  def self.human_attribute_name(attr, options = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

end
