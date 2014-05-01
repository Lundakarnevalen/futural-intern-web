class AddWarehouseCodeToInventories < ActiveRecord::Migration
  def change
    add_column :inventories, :warehouse_code, :integer
  end
end
