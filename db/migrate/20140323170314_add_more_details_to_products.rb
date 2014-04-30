# -*- encoding : utf-8 -*-
class AddMoreDetailsToProducts < ActiveRecord::Migration
  def change
    add_column :products, :warehouse_code, :integer
    add_column :products, :sale_price, :float
  end
end
