# -*- encoding : utf-8 -*-
class Intresse < ActiveRecord::Base
  has_and_belongs_to_many :karnevalister
end
