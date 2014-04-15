# -*- encoding : utf-8 -*-
class Nation < ActiveRecord::Base
  has_many :karnevalister

  def to_s
    self.name
  end
end
