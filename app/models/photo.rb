class Photo < ActiveRecord::Base
  belongs_to :karnevalist
  mount_uploader :image, FotoUploader
end
