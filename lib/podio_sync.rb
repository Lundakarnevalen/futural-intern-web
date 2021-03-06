# -*- encoding : utf-8 -*-
require 'podio'
require 'yaml'

### Code to handle Podio/Heroku sync of records.
#
# Usage: login should be performed as part of application initialisation.
# PodioSync.perform_sync is the main interface. Karnevalister are processed
# in order of oldest change. The last changes synced are stored and used to 
# resume the sync when it fails.

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
    return true
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
    @last_sync = Sync.last || Time.at(0)
  end

  def self.clear_last_log
    @last_log = ''
  end

  def self.last_log
    @last_log
  end

  def self.log str
    @last_log ||= ''
    @last_log << "Podio Sync: #{str}\n"
    @logger ||= Logger.new('log/podio_sync.log')
    Rails.logger.info "  Podio Sync: #{str}"
    @logger.info "  Podio Sync: #{str}"
  end

  def self.log_fail str
    @last_log ||= ''
    @last_log << "Sync Fail:  #{str}\n"
    @logger ||= Logger.new('log/podio_sync.log')
    Rails.logger.fatal "  Sync Fail:  #{str}"
    @logger.fatal "  Sync Fail:  #{str}"
  end

  def self.reset!
    instance_variables.reject{ |v| [:@app_id, :@login].include? v }.each do |v|
      remove_instance_variable v
    end
    self.prelims
  end

  class PodioSyncError < StandardError
  end

  ### UI methods
  def self.perform_sync
    self.log "Begin podio sync at #{Time.now}"
    self.prelims
    # Don't change order!
    to_sync = Karnevalist.where('updated_at > ?', @last_sync)
                         .order('updated_at asc').includes(:sektioner)
    if to_sync.empty?
      self.log "Already up to date."
      return true
    end
    success = nil
    this_sync = @last_sync
    synced_records = 0
    current_k = nil
    begin
      # Hack AR to not update the timestamps
      ActiveRecord::Base.record_timestamps = false
      to_sync.each do |k|
        self.clear_last_log
        current_k = k
        self.sync_karnevalist k
        this_sync = k.updated_at
        synced_records += 1
      end
    rescue Exception => e
      self.log_fail "Choked on karnevalist id == #{current_k.id}"
      self.log_fail "Sync aborted at #{Time.now}"
      self.log_fail "  due to #{e.class} (#{e.message})"
      success = false
    else
      self.log "Sync completed successfully at #{Time.now}"
      success = true
    ensure
      ActiveRecord::Base.record_timestamps = true
    end

    self.log "Processed #{synced_records} records"
    self.log "Changes synced until #{this_sync}"
    if this_sync != @last_sync
      Sync.create :time => this_sync
      @last_sync = this_sync
    end
    return success
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

  def self.get_raw_karnevalist podio_id
    self.prelims
    self.log "GET /item/#{podio_id}"
    self.attributes_from_podio(Podio::Item.find_basic podio_id)
  end


  def self.get_karnevalist local_karnevalist
    self.prelims
    if local_karnevalist.podio_id.present?
      begin
        self.to_karnevalist(
          self.get_raw_karnevalist local_karnevalist.podio_id)
      rescue Podio::NotFoundError => e
        fail PodioSyncError, 
             "Not found (podio_id == #{local_karnevalist.podio_id})"
      end
    else
      self.log "POST /item/app/#{@app_id}/filter"
      ks = Podio::Item.find_by_filter_values @app_id, 
        { 'personnummer-2' => local_karnevalist.personnummer }
                               
      if ks.count == 0
        return nil 
      elsif ks.count > 1
        self.log "Warning: " +
          "Multiple matches for personnummer == #{local_karnevalist.personnummer}"
      end
      self.to_karnevalist(self.attributes_from_podio ks.all.first)
    end
  end

  LIMIT = 500 # Max 500
  RETRIES = 2

  def self.get_all_karnevalist
    self.prelims
    pks = []
    i = 0
    total = 0
    first = true
    re_try = 0
    while true
      if first
        self.log "GET /item/app/#{@app_id}"
        first = false
      end
      begin
        resp = Podio::Item.find_all @app_id, :limit => 500, :offset => i
      rescue Faraday::Error::ConnectionFailed => e
        if re_try < RETRIES
          if re_try == 0
            self.log 'Podio fucked up, let\'s try again in 5 secs'
          else
            self.log 'Trying again'
          end

          re_try += 1
          sleep 5
          retry
        else
          self.log 'Retry fails, sorry'
          fail e
        end
      end
      re_try = 0

      total = resp.count
      i += resp.all.count
      self.log "  Receieved #{i} / #{total}"
      pks += resp.all
      if i >= total
        break
      end
    end
    self.log 'Got all records, processing...'
    return pks.map{ |pk| self.to_karnevalist self.attributes_from_podio pk }
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
    self.prelims
    if lk.podio_id.present?
      # Already linked
      self.put_karnevalist lk
      return true
    elsif lk.personnummer.present?
      # Has matching candidate?
      pk = self.get_karnevalist lk
      if pk.present?
        lk.update_attributes :podio_id => pk.podio_id
        self.log "Linked local == #{lk.id} with podio == #{pk.podio_id}"
        self.put_karnevalist lk
        return pk.podio_id
      end
    end
    # New karnevalist
    self.create_karnevalist lk
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

  def self.put_raw_karnevalist pk
    self.prelims
    self.log "PUT /item/#{pk['podio-id']}"
    Podio::Item.update pk['podio-id'], 'fields' => pk.except('podio-id')
  end

  def self.put_karnevalist karnevalist
    self.prelims
    unless karnevalist.podio_id.present?
      fail PodioSyncError, 
           "Can't put karnevalist with no podio_id (local == #{karnevalist.id})"
    end
    pk = self.to_podio_karnevalist karnevalist
    pk['podio-id'] = karnevalist.podio_id
    begin
      self.put_raw_karnevalist pk
    rescue Podio::GoneError
      self.log "Karnevalist was gone (podio_id == #{karnevalist.podio_id}), creating new"
      karnevalist.podio_id = nil
      self.create_karnevalist karnevalist
      return
    end

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
    unless karnevalist.podio_id.present?
      self.log "Delete: Nothing to do for karnevalist (id == #{karnevalist.id})"
      return
    end
    self.log "DELETE /item/#{karnevalist.podio_id}"
    podio_id = karnevalist.podio_id
    Podio::Item.delete podio_id
    karnevalist.update_attributes :podio_id => nil
    self.log "Broke link with local == #{karnevalist.id} (was podio == #{podio_id})"
  end

  def self.consolidate_karnevalister pid1, pid2
    self.prelims
    pk1 = self.get_raw_karnevalist pid1
    pk2 = self.get_raw_karnevalist pid2
    cpk = pk2.merge pk1
    cpk['podio-id'] = pid1
    self.put_raw_karnevalist cpk
    # self.delete_karnevalist (Karnevalist.new :podio_id => pid2)
    return true
  end

  ### Local read methods
  def self.local_orphans
    Karnevalist.where(:podio_id => nil).includes(:sektioner).to_a
  end

  ### Conversion methods
  def self.to_karnevalist attributes
    k = Karnevalist.new

    k.podio_id = attributes['podio-id']
    k.fornamn = attributes['title']
    k.efternamn = attributes['efternamn']
    k.personnummer = attributes['personnummer-2']
    k.kon = self.to_local Kon, attributes['kon']
    k.sektion = self.to_local_sektion(attributes['sektion-2'], 
                                      attributes['category'])
    k.telnr = attributes['mobilnummer-2']
    k.email = attributes['mail']
    k.matpref = attributes['matpreferenser']
    k.gatuadress = attributes['adress']
    k.postnr = attributes['postnummer-och-ort']
    k.postort = attributes['postort']
    k.nation = self.to_local Nation, attributes['studentnation']
    k.storlek = self.to_local Storlek, attributes['trojstorlek']
    k.korkort = self.to_local Korkort, attributes['korkortsbehorighet']
    k.medlem_af = attributes['medlem-af'] == 1
    k.medlem_kar = attributes['medlem-kar'] == 1

    return k
  end

  def self.to_podio_karnevalist lk
    { 'title' => lk.fornamn.present?? lk.fornamn : nil,
      'efternamn' => lk.efternamn.present?? lk.efternamn : nil,
      'personnummer-2' => lk.personnummer.present?? lk.personnummer : nil,
      'kon' => self.to_podio(Kon, lk.kon_id),
      'sektion-2' => self.to_podio_sektion(lk.tilldelad_sektion)[0],
      'category' => self.to_podio_sektion(lk.tilldelad_sektion)[1],
      'mobilnummer-2' => lk.telnr.present?? lk.telnr : nil,
      'mail' => lk.email,
      'matpreferenser' => lk.matpref.present?? lk.matpref : nil,
      'adress' => lk.gatuadress.present?? lk.gatuadress : nil,
      'postnummer-och-ort' => lk.postnr.present?? lk.postnr : nil,
      'postort' => lk.postort.present?? lk.postort : nil,
      'studentnation' => self.to_podio(Nation, lk.nation_id),
      'trojstorlek' => self.to_podio(Storlek, lk.storlek_id),
      'korkortsbehorighet' => self.to_podio(Korkort, lk.korkort_id),
      'medlem-af' => lk.medlem_af ? 1 : 2,
      'medlem-kar' => lk.medlem_kar ? 1 : 2,
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
        when 'image'
          nil
        else
          fail PodioSyncError, "Can't convert type #{field['type']}"
        end
    end
    a
  end

  def self.to_local model, podio_id
    @podio_categories ||= {}
    @podio_categories[model] ||= model.all.map{ |m| [m.podio_id, m] }.to_hash
    return nil if podio_id.nil?
    x = @podio_categories[model][podio_id]
    if x.nil?
      #fail PodioSyncError, 
      self.log "Warning: Can't find #{model} with (podio_id == #{podio_id})"
    end
    x
  end

  def self.to_podio model, local_id
    @local_categories ||= {}
    @local_categories[model] ||= model.all.map{ |m| [m.id, m.podio_id] }.to_hash
    if local_id.nil?
      nil
    else
      @local_categories[model][local_id]
    end
  end

  def self.to_podio_sektion local_id
    @local_conv_sektioner ||= Sektion.all.map{ |s| [s.id, s] }.to_hash
    return [nil, nil] if local_id.nil?
    s = @local_conv_sektioner[local_id]
    return s.nil?? [nil, nil] : [s.podio_id, s.podio_sub_id]
  end

  def self.to_local_sektion podio_id, podio_sub_id = nil
    @podio_conv_sektioner ||= Sektion.all.group_by &:podio_id
    return nil if podio_id.nil?
    ss = @podio_conv_sektioner[podio_id]
    if ss.empty?
      fail PodioSyncError, "Can't find sektion with (podio_id == #{podio_id})"
    end
    if podio_sub_id.nil? 
      ss = ss.select{ |s| s.podio_sub_id == nil }
      if ss.length > 1
        fail PodioSyncError, "Several sektion satisfy (podio_id == #{podio_id})"
      else
        return ss.first
      end
    else
      subss = ss.select{ |s| s.podio_sub_id == podio_sub_id }
      if subss.empty? 
        #fail PodioSyncError, 
        self.log "Warning: Can't find sektion with (podio_id == #{podio_id}, podio_sub_id == #{podio_sub_id})"
        return ss[podio_id]
      elsif subss.length > 1
        fail PodioSyncError, "Several sektion satisfy (podio_id == #{podio_id}, podio_sub_id == #{podio_sub_id})"
      else
        return ss.first
      end
    end
  end

  def self.mangle_personnummer pnr
    if pnr.present?
      pnr[0..5] + '-' + pnr[6..-1]
    else
      ''
    end
  end
end

