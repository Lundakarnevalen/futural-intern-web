# -*- encoding : utf-8 -*-
class CreateIncomingDeliveries < ActiveRecord::Migration
  def change
    create_table :incoming_deliveries do |t|
      t.string :invoice_nbr
      t.integer :warehouse_code
      t.boolean :ongoing

      t.timestamps
    end
  end
end
