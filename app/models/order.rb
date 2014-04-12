class Order < ActiveRecord::Base
  belongs_to :karnevalist
  belongs_to :sektion
  has_many :order_products
  has_many :products, through: :order_products
  validates :karnevalist, presence: true
  validates :sektion, presence: true
  before_create :set_order_date, :set_order_number
  validates :delivery_date, presence: true, on: :update

  accepts_nested_attributes_for :order_products, :reject_if => proc { |a| a['amount'].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :products
  
  HUMANIZED_ATTRIBUTES = {
    :delivery_date => "Hämtdatum",
    :sektion => "Sektion",
    :karnevalist => "Kund"
  }

  def self.human_attribute_name(attr, options = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

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
    sum = 0
    self.products.each do |p|
      sum += p.total_price(p.amount(self.id))
    end
    return sum
  end

  def self.my_active_orders_total_sum(karnevalist_id, warehouse_code)
    sum = 0
    Order.where("status IS NOT NULL AND finished_at IS NULL AND warehouse_code = ? AND karnevalist_id = ?", warehouse_code, karnevalist_id).each do |o|
      sum += o.total_sum
    end
    return sum
  end
  
  def self.my_completed_orders_total_sum(karnevalist_id, warehouse_code)
    sum = 0
    Order.where("status IS NOT NULL AND finished_at IS NOT NULL AND warehouse_code = ? AND karnevalist_id = ?", warehouse_code, karnevalist_id).each do |o|
      sum += o.total_sum
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

  def find_week_number weeks
    weeks.each do |w|
      #hash[k.to_sym]
      day_1 = 'day_1'
      day_7 = 'day_7'
      week = 'week'
      if (self.finished_at >= w[day_1.to_sym]) && (self.finished_at <= w[day_7.to_sym])
        return w[week.to_sym]
      end
    end
  end

  def self.find_orders_in_week week, warehouse_code
    orders = Order.where("finished_at >= ?", week[:day_1]).where("finished_at <= ?", week[:day_7]).where(warehouse_code:  warehouse_code)
    return orders
  end

  def self.has_week week, warehouse_code
    orders = Order.where("finished_at >= ?", week[:day_1]).where("finished_at <= ?", week[:day_7]).where(warehouse_code: warehouse_code)
    if orders.count >= 1
      return true
    else
      return false
    end
  end

end
