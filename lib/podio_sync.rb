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

  def self.prelims_noschema
    fail PodioSyncError, 'No connection to Podio' unless @login
  end

  def self.prelims
    self.prelims_noschema
    self.podio_schema unless @podio_schema
    self.last_sync unless @last_sync
  end

  def self.podio_schema
    self.prelims_noschema
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
    self.prelims
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

  def self.get_karnevalist local_karnevalist
    self.prelims
    if local_karnevalist.podio_id.present?
      self.log "GET /item/#{local_karnevalist.podio_id}"
      self.attributes_from_podio \
        Podio::Item.find_basic local_karnevalist.podio_id
    else
      self.log "POST /item/app/#{@app_id}/filter"
      ks = Podio::Item.find_by_filter_values @app_id, 
        { 'personnummer-2' => local_karnevalist.personnummer }
      if ks.count == 0
        nil 
      elsif ks.count > 1
        fail PodioSyncError, 
          "Multiple matches for personnummer == #{local_karnevalist.personnummer}"
      else
        self.attributes_from_podio ks.all.first
      end
    end
  end

  def self.get_edited_since time
    self.prelims
    self.log "POST /item/app/#{@app_id}/filter"
    ks = Podio::Item.find_by_filter_values @app_id,
      { 'last_edit_on' => { 'from' => time.to_s } },
      { 'limit' => 500 } # Maximum allowed
    ks.all.map{ |k| self.attributes_from_podio k }
  end

  def self.to_karnevalist attributes
    k = Karnevalist.new

    k.podio_id = attributes['podio-id']
    k.fornamn = attributes['title']
    k.efternamn = attributes['efternamn']
    k.personnummer = attributes['personnummer-2']
    k.tilldelad_sektion = self.sektion_to_local attributes['sektion-2']
    return k
  end

  def self.attributes_from_podio podio_obj
    a = {}
    a['podio-id'] = podio_obj.id
    podio_obj.fields.each do |field|
      a[field['external_id']] = \
        case field['type']
        when 'text'
          field['values'][0]['value']
        when 'category'
          field['values'][0]['value']['id']
        else
          fail PodioSyncError, "Can't convert type #{field['type']}"
        end
    end
    a
  end

  def self.sektion_to_local id
    @expected_sektioner[id]
  end

  def self.print_podio_schema
    self.prelims
    width = @podio_schema.keys.max_by{ |name| name.length }.length
    @podio_schema.each do |name, type|
      printf "%#{width}s : %s\n", name, type
    end
    nil
  end

  def self.last_sync
    @last_sync = Sync.last
  end

  def self.log str
    Rails.logger.info "  Podio Sync: #{str}"
  end

  class PodioSyncError < StandardError
  end
end

