class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :content
      t.integer :sektion_id

      t.timestamps
    end
    add_index :posts, [:sektion_id, :created_at]
  end
end
