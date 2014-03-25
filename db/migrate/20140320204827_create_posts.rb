class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.string :content
      t.integer :sektion_id
      t.integer :karnevalist_id

      t.timestamps
    end
    add_index :posts, [:sektion_id, :karnevalist_id, :created_at]
  end
end
