# -*- encoding : utf-8 -*-
class Sync < ActiveRecord::Base
  self.table_name = 'podio_syncs'

  def self.last
    sync = self.order('time desc').limit(1).first
    sync.nil?? Time.at(0) : sync.time
  end

  def self.register
    self.create :time => Time.now
  end
end
