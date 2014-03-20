class Sektion < ActiveRecord::Base
  has_and_belongs_to_many :karnevalister
  has_many :posts, :through => :karnevalister

  def members
    Karnevalist.where :tilldelad_sektion => self.id
  end

  def to_s
    self.name
  end
end
