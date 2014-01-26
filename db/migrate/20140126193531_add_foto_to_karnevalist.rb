class AddFotoToKarnevalist < ActiveRecord::Migration
  def change
    add_attachment :karnevalister, :foto
  end
end
