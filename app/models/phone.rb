# -*- encoding : utf-8 -*-
class Phone < ActiveRecord::Base
  validates_uniqueness_of :google_token
end
