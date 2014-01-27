class AddUserIdToKarnevalister < ActiveRecord::Migration
  def change
    change_table :karnevalister do |t|
      t.integer :user_id
    end
  end
end
