class Karnevalist < ActiveRecord::Base
  has_and_belongs_to_many :intressen
  accepts_nested_attributes_for :intressen
  has_and_belongs_to_many :sektioner
  accepts_nested_attributes_for :sektioner
  belongs_to :kon
  belongs_to :nation
  belongs_to :storlek
  belongs_to :korkort

  has_attached_file :foto, styles: {
    thumb: '100x100>',
    square: '200x200#',
    medium: '300x300>'
  }
end
