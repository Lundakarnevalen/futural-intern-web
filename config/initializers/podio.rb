require 'yaml'
require 'podio_sync'

podio_config = Rails.root.join '.podio'

if File.exists? podio_config
  PodioSync.setup(YAML.load_file(podio_config))
end
