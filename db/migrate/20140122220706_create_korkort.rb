# -*- encoding : utf-8 -*-
class CreateKorkort < ActiveRecord::Migration
  def change
    create_table :korkort do |t|
      t.string :name, :null => false
    end
  end
end
