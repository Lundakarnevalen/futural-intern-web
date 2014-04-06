class DropTableOrdersProducts < ActiveRecord::Migration
  def change
    drop_table :orders_products
  end
end
