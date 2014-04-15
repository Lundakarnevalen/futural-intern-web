# -*- encoding : utf-8 -*-
class AddIndexes < ActiveRecord::Migration
  def change
    add_index :karnevalister_sektioner, :karnevalist_id
    add_index :karnevalister_sektioner, :sektion_id
    add_index :intressen_karnevalister, :karnevalist_id
    add_index :intressen_karnevalister, :intresse_id
    add_index :karnevalister, :snalla_intresse
    add_index :karnevalister, :snalla_sektion
    add_index :karnevalister, :fornamn
    add_index :karnevalister, :efternamn
  end
end
