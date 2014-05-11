# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  # storage :file
  storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg png pdf)
  end

  version :pdf_thumb, :if => :is_pdf? do
    process :resize_to_limit => [250, 250]
    process :convert => :jpg
    process :set_content_type
  end

  private

  def set_content_type(*args)
    self.file.instance_variable_set(:@content_type, "image/jpg")
  end

  def is_pdf? picture
    picture.file.split('.').last == 'pdf'
  end

end
