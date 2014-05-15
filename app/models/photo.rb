class Photo < ActiveRecord::Base
  belongs_to :karnevalist
  mount_uploader :image, FotoUploader
  validates :karnevalist, presence: true
  validates_presence_of :image
  validates_length_of :caption, maximum: 140, allow_blank: true

  def as_json(options = {})
    {
      name: "#{self.karnevalist.fornamn} #{self.karnevalist.efternamn}",
      url: self.image.url,
      thumb: self.image.thumb.url,
      medium: self.image.medium.url,
      official: self.official,
      caption: self.caption,
      id: self.id
    }
  end
end
