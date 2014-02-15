require 'yaml'
require 'podio_sync'

PODIO_CONFIG = Rails.root.join 'config/podio.yaml'
PODIO_LOGIN = Rails.root.join 'config/podio_login.yaml'


begin
  config = YAML.load_file PODIO_CONFIG

  if File.exists?(PODIO_LOGIN) && ['production', 'development'].include?(Rails.env)
    config.merge! YAML.load_file(PODIO_LOGIN)
  end

  PodioSync.setup config
rescue Exception => e
  puts "Connection to Podio failed, lib says `#{e.message}`"
end

