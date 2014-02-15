require 'podio'
require 'yaml'

# Code to handle Podio/Heroku sync of records.

module PodioSync
  def self.setup config
    if config.has_key? 'login'
      login = config['login']
      @app_id = login['app_id']
      @login = true
      Podio.setup({ :api_key => login['api_key'], 
                    :api_secret => login['api_secret'] })
      Podio.client.authenticate_with_app(login['app_id'], login['app_key'])
    end
    @expected_schema = config['schema']
    @expected_sektioner = config['sektioner']
    true
  end

  def self.get_podio_schema
    unless @login
      fail PodioSyncError, 'Not logged into podio'
    end
    self.log "GET /app/#{@app_id}"
    fields = Podio::Application.find(@app_id).fields
    @podio_schema = fields.map{ |f| [f['external_id'], f['type']] }.to_hash
    sektion_obj = fields.select{ |f| f['external_id'] == 'sektion-2'}[0]
    unless sektion_obj.present?
      fail 'Field `sektion` missing from Podio'
    end
    @podio_sektioner = sektion_obj['config']['settings']['options']
    @podio_schema
  end

  def self.ensure_schemas_match
    @expected_schema.each do |name, type|
      podio_type = @podio_schema[name]
      unless podio_type == type
        fail PodioSyncError, 
             "Schema mismatch on `#{name}`: expected #{type} but was #{podio_type}"
      end
    end
    @podio_sektioner.each do |sektion|
      unless @expected_sektioner.has_key? sektion['id']
        fail PodioSyncError,
             "Unknown sektion `#{sektion['text']}` with id == #{sektion['id']}"
      end
    end
    true
  end

  def self.to_karnevalist podio_obj
    k = Karnevalist.new
    k.fornamn = self.convert_attribute podio_obj, 'title' do |a|
      self.separate_names(a).first
    end
    k.efternamn = self.convert_attribute podio_obj, 'title' do |a|
      self.separate_names(a).last
    end
    k.personnummer = self.convert_attribute podio_obj, 'personnummer-2' do |a|
      a
    end
    k.tilldelad_sektion = self.convert_attribute podio_obj, 'sektion-2' do |a|
      self.sektion_to_local a
    end
    k
  end

  def self.convert_attribute podio_obj, attribute, &block
    if podio_obj.has_key? attribute
      yield podio_obj[attribute]
    else 
      nil
    end
  end
  
  def self.separate_names name
    words = name.split ' '
    [words.first, words[1..-1]]
  end

  def self.sektion_to_local id
    @expected_sektioner[id]
  end

  def self.print_podio_schema
    @podio_schema || self.get_podio_schema
    width = @podio_schema.keys.max_by{ |name| name.length }.length
    @podio_schema.each do |name, type|
      printf "%#{width}s : %s\n", name, type
    end
    nil
  end

  def self.log str
    Rails.logger.info "  Podio Sync: #{str}"
  end

  class PodioSyncError < StandardError
  end
end

