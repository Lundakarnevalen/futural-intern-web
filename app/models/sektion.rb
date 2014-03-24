class Sektion < ActiveRecord::Base
  has_and_belongs_to_many :karnevalister

  def members
    Karnevalist.where 'tilldelad_sektion = ? or tilldelad_sektion2 = ?',
                      self.id, self.id
  end

  def to_s
    self.name
  end
end
