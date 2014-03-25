class Order < ActiveRecord::Base
  belongs_to :karnevalist
  has_many :products, :through => :orders_products
  has_many :orders_products
  validates :karnevalist, presence: true
  before_save :set_order_date

  def set_order_date
    self.order_date = Date.today if self.order_date.blank?
  end
end
