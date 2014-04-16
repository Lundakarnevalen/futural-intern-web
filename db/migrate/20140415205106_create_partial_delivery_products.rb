class CreatePartialDeliveryProducts < ActiveRecord::Migration
  def change
    create_table :partial_delivery_products do |t|
      t.integer :partial_delivery_id
      t.integer :product_id
      t.integer :amount

      t.timestamps
    end
  end
end
