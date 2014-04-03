class CreateKarnevalisterIncomingDeliveriesJoinTable < ActiveRecord::Migration
  def change
    create_table :karnevalister_incoming_deliveries, id: false do |t|
      t.integer :karnevalist_id
      t.integer :incoming_delivery_id
    end 
  end
end
