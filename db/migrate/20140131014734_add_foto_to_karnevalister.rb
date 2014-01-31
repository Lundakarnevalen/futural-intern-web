class AddFotoToKarnevalister < ActiveRecord::Migration
  def change
    add_column :karnevalister, :foto, :string
  end
end
