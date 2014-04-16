class AddDeliveredAmountToOrderProducts < ActiveRecord::Migration
  def change
    add_column :order_products, :delivered_amount, :integer, :default => 0
  end
end
