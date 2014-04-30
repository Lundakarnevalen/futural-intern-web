# -*- encoding : utf-8 -*-
class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.text :text

      t.timestamps
    end
  end
end
