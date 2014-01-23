class CreateKarnevalisterSektioner < ActiveRecord::Migration
  def change
    create_table :karnevalister_sektioner do |t|
      t.integer :karnevalist_id, :null => false
      t.integer :sektion_id, :null => false
    end
  end
end
