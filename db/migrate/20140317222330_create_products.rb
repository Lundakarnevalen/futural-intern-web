# -*- encoding : utf-8 -*-
class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.integer :product_type
      t.references :product_category, index: true
      t.string :name
      t.string :unit
      t.string :ean
      t.string :supplier
      t.text :info
      t.string :stock_location
      t.text :notes
      t.integer :stock_balance_ordered
      t.integer :stock_balance_not_ordered
      t.integer :stock_balance_stand_by
      t.float :purchase_price

      t.timestamps
    end
  end
end
