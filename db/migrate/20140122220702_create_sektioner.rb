# -*- encoding : utf-8 -*-
class CreateSektioner < ActiveRecord::Migration
  def change
    create_table :sektioner do |t|
      t.string :name, :null => false
    end
  end
end
