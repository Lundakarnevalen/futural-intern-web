# -*- encoding : utf-8 -*-
class AddDetailsToKarnevalister < ActiveRecord::Migration
  def change
    change_column :karnevalister, :google_token, :text, :limit => nil
    remove_column :karnevalister, :utcheckad
    add_column :karnevalister, :utcheckad, :integer, :default => 1

    # change_column :karnevalister, :utcheckad, 'integer USING CAST(utcheckad AS integer)'
  end
end
