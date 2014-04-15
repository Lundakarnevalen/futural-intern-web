# -*- encoding : utf-8 -*-
class CreateNationer < ActiveRecord::Migration
  def change
    create_table :nationer do |t|
      t.string :name, :null => false
    end
  end
end
