class Order < ActiveRecord::Base
  belongs_to :karnevalist
  has_many :order_products
  has_many :products, through: :order_products
  validates :karnevalist, presence: true
  before_save :set_order_date

  accepts_nested_attributes_for :order_products, :reject_if => proc { |a| a['amount'].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :products

  def set_order_date
    self.order_date = DateTime.now if self.order_date.blank?
  end

  def start_time
    self.delivery_date
  end

  def total_sum
    sum = 0;
    self.products.each do |p|
      sum += p.total_price(p.amount(self.id))
    end
    return sum
  end

end
