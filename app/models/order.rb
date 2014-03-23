class Order < ActiveRecord::Base
  belongs_to :karnevalist
  has_and_belongs_to_many :products
  validates :karnevalist, presence: true
  before_save :set_order_date

  def set_order_date
    self.order_date = Date.today unless self.order_date
  end
end
