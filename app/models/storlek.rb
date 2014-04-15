# -*- encoding : utf-8 -*-
class Storlek < ActiveRecord::Base
  has_many :karnevalister

  def to_s
    self.name
  end
end
