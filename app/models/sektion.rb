class Sektion < ActiveRecord::Base
  has_and_belongs_to_many :karnevalister
  has_many :posts
  has_many :orders
  validates :info_page

  def members
    Karnevalist.where 'tilldelad_sektion = ? or tilldelad_sektion2 = ?',
                      self.id, self.id
  end

  def to_s
    self.name
  end
end
