# -*- encoding : utf-8 -*-
class AddTilldeladKlarToKarnevalister < ActiveRecord::Migration
  def change
    add_column :karnevalister, :tilldelad_klar, :boolean
  end
end
