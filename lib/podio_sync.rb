require 'podio'
require 'yaml'

module PodioSync
  def self::setup config
    @config = config
    Podio::setup({ :api_key => config['api_key'], 
                   :api_secret => config['api_secret'] })
    Podio::client.authenticate_with_app(config['app_id'], config['app_key'])
    true
  end

  def self::get_podio_schema
    self::log "GET /app/#{self::app_id}"
    Podio::Application.find(self::app_id).fields
  end

  def self::present_schema schema
    width = schema.map { |field| field['external_id'] }
                  .max_by { |name| name.length }.length
    schema.each do |field|
      printf "%#{width}s :: %s\n", field['external_id'], field['type']
    end
    nil
  end

  def self::app_id
    @config['app_id']
  end

  def self::log str
    Rails::logger.info "Podio Sync: #{str}"
  end
end

