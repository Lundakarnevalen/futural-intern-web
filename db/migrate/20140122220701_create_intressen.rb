# -*- encoding : utf-8 -*-
class CreateIntressen < ActiveRecord::Migration
  def change
    create_table :intressen do |t|
      t.string :name, :null => false
    end
  end
end
