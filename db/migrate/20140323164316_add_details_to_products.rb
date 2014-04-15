# -*- encoding : utf-8 -*-
class AddDetailsToProducts < ActiveRecord::Migration
  def change
    change_column :products, :stock_balance_ordered, :integer, :default => 0
    change_column :products, :stock_balance_not_ordered, :integer, :default => 0
    change_column :products, :stock_balance_stand_by, :integer, :default => 0
  end
end
