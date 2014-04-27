class Photo < ActiveRecord::Base
  belongs_to :karnevalist
  mount_uploader :image, FotoUploader
  validates :karnevalist, presence: true
  validates_presence_of :image

  def as_json(options = {})
    {
      name: "#{self.karnevalist.fornamn} #{self.karnevalist.efternamn}",
      url: self.image.url,
      official: self.official,
      id: self.id
    }
  end

end
