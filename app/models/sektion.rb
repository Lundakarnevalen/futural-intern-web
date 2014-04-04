class Sektion < ActiveRecord::Base
  has_and_belongs_to_many :karnevalister
  has_many :orders

  def members
    Karnevalist.where :tilldelad_sektion => self.id
  end
end
