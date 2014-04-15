# -*- encoding : utf-8 -*-
class CreateIntressenKarnevalister< ActiveRecord::Migration
  def change
    create_table :intressen_karnevalister do |t|
      t.integer :intresse_id, :null => false
      t.integer :karnevalist_id, :null => false
    end
  end
end
