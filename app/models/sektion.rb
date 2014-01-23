class Sektion < ActiveRecord::Base
  has_and_belongs_to_many :karnevalister
end
