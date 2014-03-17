class Order < ActiveRecord::Base
  belongs_to :karnevalist
  has_and_belongs_to_many :products
end
