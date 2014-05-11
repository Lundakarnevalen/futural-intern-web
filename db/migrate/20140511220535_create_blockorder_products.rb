class CreateBlockorderProducts < ActiveRecord::Migration
  def change
    create_table :blockorder_products do |t|
      t.integer :blockorder_id
      t.integer :product_id
      t.integer :amount

      t.timestamps
    end
  end
end
