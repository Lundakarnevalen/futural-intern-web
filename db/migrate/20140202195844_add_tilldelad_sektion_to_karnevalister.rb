class AddTilldeladSektionToKarnevalister < ActiveRecord::Migration
  def change
    add_column :karnevalister, :tilldelad_sektion, :integer
  end
end
