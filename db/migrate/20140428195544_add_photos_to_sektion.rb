class AddPhotosToSektion < ActiveRecord::Migration
  def change
    add_column :sektioner, :photos, :photo_id
  end
end
