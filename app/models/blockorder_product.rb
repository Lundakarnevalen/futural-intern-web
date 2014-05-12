# -*- encoding : utf-8 -*-
class BlockorderProduct < ActiveRecord::Base
  belongs_to :blockorder
  belongs_to :product
end
