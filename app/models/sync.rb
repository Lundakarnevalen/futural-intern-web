class Sync < ActiveRecord::Base
  self.table_name = 'podio_syncs'

  def self.last
    sync = self.order('time desc').limit(1).first
    sync.nil?? Time.at(0) : sync.time
  end
end
