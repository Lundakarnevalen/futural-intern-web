class Photo < ActiveRecord::Base
    mount_uploader :file, SektionPhotosUploader
end
