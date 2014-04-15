# -*- encoding : utf-8 -*-
class AddAktivToKarnevalister < ActiveRecord::Migration
  def change
    add_column :karnevalister, :aktiv, :boolean, :default => false
  end
end
