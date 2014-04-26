class Photo < ActiveRecord::Base
  belongs_to :karnevalist
  mount_uploader :image, FotoUploader
  validates :karnevalist, presence: true
  validates_presence_of :image
  def as_json(options = {})
  end
end
