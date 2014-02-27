require 'podio'
require 'yaml'

# Code to handle Podio/Heroku sync of records.

module PodioSync
  ### General startup and bookkeeping
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
    true
  end

  def self.expected_schema
    self.prelims
    @expected_schema
  end

  def self.ensure_login
    fail PodioSyncError, 'No connection to Podio' unless @login
  end

  def self.prelims
    self.ensure_login
    self.podio_schema unless @podio_schema
    self.last_sync unless @last_sync
  end

  def self.ensure_schemas_match
    self.prelims
    @expected_schema.each do |name, type|
      podio_type = @podio_schema[name]
      unless podio_type == type
        fail PodioSyncError, 
             "Schema mismatch on `#{name}`: expected #{type} but was #{podio_type || 'missing'}"
      end
    end

    ids = @podio_sektioner.map{ |s| s['id'] }
    unless Sektion.where(:podio_id => ids).count == ids.length
      # Fast version did not work, find which section messed up.
      @podio_sektioner.each do |sektion|
        unless Sektion.where(:podio_id => sektion['id']).exists?
          fail PodioSyncError,
               "Unknown sektion `#{sektion['text']}` with id == #{sektion['id']}"
        end
      end
    end
    true
  end

  def self.last_sync
    @last_sync = Sync.last
  end

  def self.log str
    Rails.logger.info "  Podio Sync: #{str}"
  end

  class PodioSyncError < StandardError
  end

  ### UI methods
  def self.perform_sync
    self.log "Begin podio sync at #{Time.now}"
    self.prelims
    to_sync = [] +
      self.local_edited +
      self.local_orphans
    begin
      to_sync.each do |k|
        self.sync_karnevalist k
      end
    rescue Exception => e
      self.log "Podio sync aborted at #{Time.now}"
      self.log "  due to #{e.class} (#{e.message})"
      fail
    end
    Sync.register; self.last_sync
    self.log "Podio sync completed successfully at #{Time.now}"
  end

  def self.print_podio_schema
    self.prelims
    width = @podio_schema.keys.max_by{ |name| name.length }.length
    @podio_schema.each do |name, type|
      printf "%#{width}s : %s\n", name, type
    end
    nil
  end

  ### Podio read methods
  def self.podio_schema
    self.ensure_login
    self.log "GET /app/#{@app_id}"
    fields = Podio::Application.find(@app_id).fields
    @podio_schema = fields.map{ |f| [f['external_id'], f['type']] }.to_hash
    sektion_obj = fields.select{ |f| f['external_id'] == 'sektion-2'}[0]
    unless sektion_obj.present?
      fail 'Field `sektion` missing from Podio'
    end
    @sektion_field_id = sektion_obj['field_id']
    @podio_sektioner = sektion_obj['config']['settings']['options']
    @podio_schema
  end

  def self.get_karnevalist local_karnevalist
    self.prelims
    if local_karnevalist.podio_id.present?
      self.log "GET /item/#{local_karnevalist.podio_id}"
      begin
        self.to_karnevalist(self.attributes_from_podio \
          Podio::Item.find_basic local_karnevalist.podio_id)
      rescue Podio::NotFoundError => e
        fail PodioSyncError, 
             "Not found (podio_id == #{local_karnevalist.podio_id})"
      end
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
        self.to_karnevalist(self.attributes_from_podio ks.all.first)
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

  ### Podio write methods
  def self.sync_karnevalist lk
    if lk.podio_id.present?
      # Already linked
      self.put_karnevalist lk
    elsif lk.personnummer.present?
      # Has matching candidate
      pk = self.get_karnevalist lk
      if pk.present?
        lk.update_attributes :podio_id => pk.podio_id
        self.log "Linked local == #{lk.id} with podio == #{pk.podio_id}"
        self.put_karnevalist lk
      end
    else
      # New karnevalist
      self.create_karnevalist lk
    end
  end

  def self.create_karnevalist karnevalist
    self.prelims
    if karnevalist.podio_id.present?
      fail PodioSyncError,
           "Can't create karnevalist with existing podio_id (== #{karnevalist.podio_id}"
    end
    k = self.to_podio_karnevalist karnevalist
    self.log "POST /item/app/#{@app_id}"
    resp = Podio::Item.create @app_id, 'fields' => k
    podio_id = resp['item_id']
    karnevalist.update_attributes :podio_id => podio_id
    self.log "Created podio_id == #{podio_id} (local == #{karnevalist.id})"
    podio_id
  end

  def self.put_karnevalist karnevalist
    self.prelims
    unless karnevalist.podio_id.present?
      fail PodioSyncError, 
           "Can't put karnevalist with no podio_id (local == #{karnevalist.id})"
    end
    k = self.to_podio_karnevalist karnevalist
    self.log "PUT /item/#{karnevalist.podio_id}"
    Podio::Item.update karnevalist.podio_id, 'fields' => k
    self.log "Synced podio_id == #{karnevalist.podio_id} with local == #{karnevalist.id}"
    karnevalist.podio_id
  end

  def self.create_sektion sektion
    # Does not work, Podio will not auth.
    self.prelims
    if sektion.new_record?
      fail PodioSyncError, 'Will not save new sektion locally'
    end
    self.log "PUT /app/#{@app_id}/field/#{@sektion_field_id}"
    req = { 'fields' => 
            [
              { 'field_id' => @sektion_field_id,
                'config' => 
                { 'settings' => 
                  { 'options' => 
                    [
                      { 'text' => sektion.name }]}}}]}
    Podio::Application.update @app_id, req
  end

  def self.delete_karnevalist karnevalist
    self.prelims
    self.log "DELETE /item/#{karnevalist.podio_id}"
    Podio::Item.delete karnevalist.podio_id
    karnevalist.update_attributes :podio_id => nil
    self.log "Broke link with local == #{karnevalist.id} (was podio == #{karnevalist.podio_id})"
  end

  ### Local read methods
  def self.local_orphans
    Karnevalist.where(:podio_id => nil).includes(:sektioner).to_a
  end

  def self.local_edited
    Karnevalist.where('updated_at > ?', @last_sync).includes(:sektioner).to_a
  end

  ### Conversion methods
  def self.to_karnevalist attributes
    k = Karnevalist.new

    k.podio_id = attributes['podio-id']
    k.fornamn = attributes['title']
    k.efternamn = attributes['efternamn']
    k.personnummer = attributes['personnummer-2']
    k.tilldelad_sektion = self.sektion_to_local attributes['sektion-2']
    k.telnr = attributes['mobilnummer-2']
    k.email = attributes['mail']
    k.matpref = attributes['matpreferenser']

    return k
  end

  def self.to_podio_karnevalist lk
    { 'title' => lk.fornamn.present?? lk.fornamn : nil,
      'efternamn' => lk.efternamn.present?? lk.efternamn : nil,
      'personnummer-2' => lk.personnummer.present?? lk.personnummer : nil,
      'sektion-2' => self.sektion_to_podio(lk.tilldelad_sektion),
      'mobilnummer-2' => lk.telnr.present?? lk.telnr : nil,
      'mail' => lk.email,
      'matpreferenser' => lk.matpref.present?? lk.matpref : nil,
    }
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

  def self.sektion_to_local podio_sektion
    return nil if podio_sektion.nil?
    s = Sektion.find_by_podio_id podio_sektion
    if s.nil?
      fail PodioSyncError, "Can't find sektion with (podio_id == #{podio_sektion})"
    end
    s.id
  end

  def self.sektion_to_podio local_sektion
    if local_sektion.nil?
      nil
    else
      Sektion.find(local_sektion).podio_id
    end
  end
end

