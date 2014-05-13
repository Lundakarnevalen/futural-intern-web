# -*- encoding : utf-8 -*-
class Order < ActiveRecord::Base
  belongs_to :karnevalist
  belongs_to :sektion
  has_many :order_products
  has_many :products, through: :order_products
  has_many :partial_deliveries
  has_many :backorders
  validates :karnevalist, presence: true
  validates :sektion, presence: true
  before_create :set_order_date, :set_order_number
  validates :delivery_date, presence: true, on: :update
  validate :delivery_date_time, on: :update, if: "!self.delivery_date.blank?"

  accepts_nested_attributes_for :order_products, :reject_if => proc { |a| a['amount'].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :products

  scope :between, lambda { |start_time, end_time|
    where("? < delivery_date < ?",
      Order.format_date(start_time),
      Order.format_date(end_time)
    )
  }
  ORDER_PATHS = {
    fabriken: 'fabriken_order_path',
    fest: 'festmasteriet_order_path',
    snaxeriet: 'snaxeriet_order_path'
  }

  def as_json(options = {})
    wh_code = options[:warehouse_code] || 0
    path = wh_code == 0 ? 'fabriken' : (wh_code == 1 ? 'fest' : 'snaxeriet')
    {
      id: self.id,
      title: self.sektion.name,
      description: "",
      start: self.delivery_date,
      end: self.delivery_date.advance(minutes: 30),
      allDay: false,
      recurring: false,
      url: Rails.application.routes.url_helpers.send(ORDER_PATHS[path.to_sym], self.id)
    }
  end

  HUMANIZED_ATTRIBUTES = {
    :delivery_date => "Hämtdatum",
    :sektion => "Sektion",
    :karnevalist => "Kund"
  }

  def self.format_date(date_time)
    Time.at(date_time.to_i).to_formatted_s(:db)
  end

  def self.human_attribute_name(attr, options = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

  def delivery_date_time
    errors.add(:delivery_date, "har redan inträffat") if DateTime.now.beginning_of_day > self.delivery_date
  end

  def set_order_date
    self.order_date = DateTime.now if self.order_date.blank?
  end

  def set_order_number
    self.order_number = Order.where(warehouse_code: self.warehouse_code).count + 1
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

  def self.sektion_active_orders_total_sum(sektioner, warehouse_code)
    sum = 0
    Order.where("status IS NOT NULL AND finished_at IS NULL AND warehouse_code = ? AND sektion_id IN (?)", warehouse_code, sektioner).each do |o|
      sum += o.total_sum
    end
    return sum
  end

  def self.sektion_completed_orders_total_sum(sektioner, warehouse_code)
    sum = 0
    Order.where("status IS NOT NULL AND finished_at IS NOT NULL AND warehouse_code = ? AND sektion_id IN (?)", warehouse_code, sektioner).each do |o|
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

  def self.find_all_dates warehouse_code
    initialize_day = DateTime.new(2014,1,1)
    year = []
    i = 2
    datelist = []
    while year.length <= 365 do
      year.push(initialize_day + i.days)
      i += 1
    end
    orders = Order.where(warehouse_code: warehouse_code, status: "Levererad").order("finished_at ASC")
    orders.each do |o|
      year.each do |y|
        if (o.finished_at >= y) && (o.finished_at < y.next)
          datelist.push(y)
          year.delete(y)
        end
      end
    end
    return datelist
  end

  def self.find_orders_in_date date, warehouse_code
    orders = Order.where("finished_at >= ? ", date).where("finished_at < ?", date + 1.day).where(warehouse_code:  warehouse_code).order("finished_at ASC")
    return orders
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
    orders = Order.where("finished_at >= ?", week[:day_1]).where("finished_at <= ?", week[:day_7]).where(warehouse_code:  warehouse_code).order("finished_at ASC")
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
