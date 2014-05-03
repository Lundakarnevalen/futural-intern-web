# -*- encoding : utf-8 -*-
CarrierWave.configure do |config|
  if Rails.env.test? || Rails.env.development?
    config.storage = :file
    config.enable_processing = true
    config.root = Rails.env.test? ? "#{Rails.root}/tmp" : "#{Rails.root}/public"
    config.asset_host = "http://localhost:3000"
  else
    config.storage = :fog
    config.fog_credentials = {
      :provider               => 'AWS',                        # required
      :aws_access_key_id      => ENV['AWS_ACCESS_KEY_ID'],                        # required
      :aws_secret_access_key  => ENV['AWS_SECRET_ACCESS_KEY'],                        # required
      :region                 => 'eu-west-1',                  # optional, defaults to 'us-east-1'
      # :host                   => 's3.example.com',             # optional, defaults to nil
      # :endpoint               => 'https://s3.example.com:8080' # optional, defaults to nil
    }
    config.fog_directory  = ENV['S3_BUCKET_NAME']                     # required
    config.fog_public     = true                                   # optional, defaults to true
    #config.fog_host      = ?
    config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
  end

end
