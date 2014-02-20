class AddPodioIdToKarnevalist < ActiveRecord::Migration
  def change
    add_column :karnevalister, :podio_id, :integer
  end
end
