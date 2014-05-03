class CreateBackorders < ActiveRecord::Migration
  def change
    create_table :backorders do |t|
      t.references :order, index: true
      t.references :product, index: true
      t.integer :amount

      t.timestamps
    end
  end
end
