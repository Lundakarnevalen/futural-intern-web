# -*- encoding : utf-8 -*-
class PartialDeliveryProduct < ActiveRecord::Base
  belongs_to :partial_delivery
  belongs_to :product
end
