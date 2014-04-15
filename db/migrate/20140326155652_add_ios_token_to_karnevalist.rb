# -*- encoding : utf-8 -*-
class AddIosTokenToKarnevalist < ActiveRecord::Migration
  def change
    add_column :karnevalister, :ios_token, :text
  end
end
