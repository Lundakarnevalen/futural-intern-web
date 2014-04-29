class Photo < ActiveRecord::Base
    mount_uploader :photo, SektionPhotosUploader
end
