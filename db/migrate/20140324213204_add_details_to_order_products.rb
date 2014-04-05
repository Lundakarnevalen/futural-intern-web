class AddDetailsToOrderProducts < ActiveRecord::Migration
  def change
    remove_column :order_products, :nbr_of_products, :integer
    add_column :order_products, :amount, :integer
  end
end
