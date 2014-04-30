# -*- encoding : utf-8 -*-
class AddFotoToKarnevalist < ActiveRecord::Migration
  def up
    # add_attachment :karnevalister, :foto
  end

  def down
    remove_attachment :karnevalister, :foto
  end
end
