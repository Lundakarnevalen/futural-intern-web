class CreateBlockorders < ActiveRecord::Migration
  def change
    create_table :blockorders do |t|
      t.integer :sektion_id
      t.integer :warehouse_code

      t.timestamps
    end
  end
end
