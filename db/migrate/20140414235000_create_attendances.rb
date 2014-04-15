class CreateAttendances < ActiveRecord::Migration
  def change
    create_table :attendances do |t|
      t.integer :event_id, :null => false
      t.integer :karnevalist_id, :null => false
      t.text :comment
      t.timestamps
    end

    add_index :attendances, [:event_id, :karnevalist_id]
  end
end
