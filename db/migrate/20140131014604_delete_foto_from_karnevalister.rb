# -*- encoding : utf-8 -*-
class DeleteFotoFromKarnevalister < ActiveRecord::Migration
  def change
    remove_column :karnevalister, :foto
  end
end
