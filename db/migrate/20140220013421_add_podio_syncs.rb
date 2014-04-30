# -*- encoding : utf-8 -*-
class AddPodioSyncs < ActiveRecord::Migration
  def change
    create_table :podio_syncs do |t|
      t.datetime :time
    end
  end
end
