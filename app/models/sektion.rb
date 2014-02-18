class Sektion < ActiveRecord::Base
  has_and_belongs_to_many :karnevalister

  def members
    Karnevalist.where :tilldelad_sektion => self.id
  end
end
