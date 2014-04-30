# -*- encoding : utf-8 -*-
require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Futural
  class Application < Rails::Application
    config.autoload_paths += ["#{config.root}/lib/**/", "#{Rails.root}/app/pdfs"]

    config.time_zone = 'Stockholm'
    config.active_record.default_timezone = :local
    config.action_view.logger = nil # Don't log partials.
    config.i18n.default_locale = :sv
    config.i18n.enforce_available_locales = true
    I18n.config.enforce_available_locales = true

    # Postmark
    config.action_mailer.delivery_method   = :postmark
    config.action_mailer.postmark_settings = { :api_key => ENV['POSTMARK_API_KEY'] }

  end
end
