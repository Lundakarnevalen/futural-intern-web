# -*- encoding : utf-8 -*-
class CreatePhones < ActiveRecord::Migration
  def change
    create_table :phones do |t|
      t.text :google_token

      t.timestamps
    end
  end
end
