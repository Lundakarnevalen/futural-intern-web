class Order < ActiveRecord::Base
  belongs_to :karnevalist
  has_many :products, :through :order_products
  validates :karnevalist, presence: true
  before_save :set_order_date

  def set_order_date
    self.order_date = Date.today unless self.order_date
  end
end
