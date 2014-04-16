class CreatePartialDeliveries < ActiveRecord::Migration
  def change
    create_table :partial_deliveries do |t|
      t.integer :order_id
      t.integer :seller_id

      t.timestamps
    end
  end
end
