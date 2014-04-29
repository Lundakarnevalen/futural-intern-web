class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.integer :sektion_id
      t.string :image
      t.string :name
      t.timestamps
    end
  end
end
