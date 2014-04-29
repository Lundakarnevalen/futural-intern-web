class AddPhotosToSektioner < ActiveRecord::Migration
  def change
    add_column :sektioner, :photo_id, :integer
  end
end
