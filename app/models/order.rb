class Order < ActiveRecord::Base
  belongs_to :karnevalist
<<<<<<< HEAD
  has_many :products, :through => :orders_products
  has_many :orders_products
=======
  has_many :order_products
  has_many :products, through: :order_products
>>>>>>> Fixed order/product connection
  validates :karnevalist, presence: true
  before_save :set_order_date

  accepts_nested_attributes_for :order_products, :reject_if => proc { |a| a['amount'].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :products

  def set_order_date
    self.order_date = Date.today if self.order_date.blank?
  end

end
