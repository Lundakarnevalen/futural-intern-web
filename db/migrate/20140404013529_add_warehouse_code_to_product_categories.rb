class AddWarehouseCodeToProductCategories < ActiveRecord::Migration
  def change
    add_column :product_categories, :warehouse_code, :integer
  end
end
