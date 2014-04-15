# -*- encoding : utf-8 -*-
class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.date :date
      t.text :description
      t.integer :sektion_id
      t.integer :creator_id
      t.timestamps
    end
  end
end
