# -*- encoding : utf-8 -*-
class IncomingDeliveryProduct < ActiveRecord::Base
  belongs_to :incoming_delivery
  belongs_to :product
end
