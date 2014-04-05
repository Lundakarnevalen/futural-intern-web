class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :status
      t.datetime :order_date
      t.datetime :delivery_date
      t.text :comment
      t.integer :warehouse_code
      t.references :karnevalist, index: true

      t.timestamps
    end
  end
end
