class RenameKarnevalisterIncomingDeliveriesToIncomingDeliveriesKarnevalister < ActiveRecord::Migration
  def change
    rename_table :karnevalister_incoming_deliveries, :incoming_deliveries_karnevalister
  end
end
