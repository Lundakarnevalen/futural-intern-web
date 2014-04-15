# -*- encoding : utf-8 -*-
class CreateIncomingDeliveryProducts < ActiveRecord::Migration
  def change
    create_table :incoming_delivery_products do |t|
      t.integer :incoming_delivery_id
      t.integer :product_id
      t.integer :amount

      t.timestamps
    end
  end
end
