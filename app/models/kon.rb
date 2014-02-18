class Kon < ActiveRecord::Base
  has_many :karnevalister

  def to_s
    self.name
  end
end
