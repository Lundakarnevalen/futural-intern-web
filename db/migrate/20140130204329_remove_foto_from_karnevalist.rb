# -*- encoding : utf-8 -*-
class RemoveFotoFromKarnevalist < ActiveRecord::Migration
  def up
    # remove_column :karnevalister, :foto_file_name
    # remove_column :karnevalister, :foto_content_type
    # remove_column :karnevalister, :foto_file_size
    # remove_column :karnevalister, :foto_updated_at
  end

  def down
    add_attachment :karnevalister, :foto
  end
end
