# -*- encoding : utf-8 -*-
class CreateOrderProducts < ActiveRecord::Migration
  def change
    create_table :order_products do |t|
      t.integer :order_id
      t.integer :product_id
      t.integer :nbr_of_products
      
      t.timestamps
    end
  end
end
