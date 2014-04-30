# -*- encoding : utf-8 -*-
class Cluster < ActiveRecord::Base
  acts_as_mappable :default_units => :kms,
                   :default_formula => :sphere

  def as_json(options = {})
    options[:except] ||= [:created_at, :updated_at]
    super(options)
  end
end
