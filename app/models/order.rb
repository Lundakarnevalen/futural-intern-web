class Order < ActiveRecord::Base
  belongs_to :karnevalist
  belongs_to :sektion
  has_many :order_products
  has_many :products, through: :order_products
  validates :karnevalist, presence: true
  before_create :set_order_date, :set_order_number

  accepts_nested_attributes_for :order_products, :reject_if => proc { |a| a['amount'].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :products

  def set_order_date
    self.order_date = DateTime.now if self.order_date.blank?
  end

  def set_order_number
    self.order_number = Order.where(warehouse_code: self.warehouse_code).count + 1
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

  def self.search str
    q = self.all
    array = []

    q.each do |order|
      sektion = Sektion.find(Karnevalist.find(order.karnevalist_id).tilldelad_sektion).name
      if str == sektion
        array.push(order)
      end
    end
    return array
  end


end
