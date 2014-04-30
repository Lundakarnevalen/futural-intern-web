# -*- encoding : utf-8 -*-
class AddMedlemKolladToKarnevalister < ActiveRecord::Migration
  def change
    add_column :karnevalister, :medlem_kollad, :boolean, :default => false
  end
end
