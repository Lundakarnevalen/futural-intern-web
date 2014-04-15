# -*- encoding : utf-8 -*-
class AddDeliveryCostToIncomingDeliveries < ActiveRecord::Migration
  def change
    add_column :incoming_deliveries, :delivery_cost, :float
  end
end
