class AddUtcheckadAtToKarnevalister < ActiveRecord::Migration
  def change
    change_table :karnevalister do |t|
      t.datetime :utcheckad_at
    end
  end
end
