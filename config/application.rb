require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Futural
  class Application < Rails::Application
    config.autoload_paths += ["#{config.root}/lib/**/"]
    config.time_zone = 'Stockholm'
    config.i18n.default_locale = :sv

    # NB this is a Bad Thing.
    config.active_record.whitelist_attributes = false
  end
end
