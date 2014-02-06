# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += [:password, :image_data]

Rails.application.config.log_tags = [ lambda { |request| request.user_agent } ]
