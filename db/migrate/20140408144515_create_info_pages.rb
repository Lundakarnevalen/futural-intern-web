class CreateInfoPages < ActiveRecord::Migration
  def change
    create_table :info_pages do |t|
      t.string :content
      t.integer :sektion_id

      t.timestamps
    end
  end
end
