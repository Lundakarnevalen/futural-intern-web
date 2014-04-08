class AddFinishedAtToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :finished_at, :datetime
  end
end
