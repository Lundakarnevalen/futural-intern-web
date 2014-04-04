class AddSektionRefToOrders < ActiveRecord::Migration
  def change
    add_reference :orders, :sektion, index: true
  end
end
