class Image < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  belongs_to :sektion
  validates :image, :presence => :true
  validates :name, :presence => :true
end
