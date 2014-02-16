class AddPusseldagKeepToKarnevalister < ActiveRecord::Migration
  def change
    add_column :karnevalister, :pusseldag_keep, :boolean
  end
end
