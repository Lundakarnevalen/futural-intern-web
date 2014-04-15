# -*- encoding : utf-8 -*-
class DropOrdersProducts < ActiveRecord::Migration
  def change
    drop_table :orders_products
  end
end
