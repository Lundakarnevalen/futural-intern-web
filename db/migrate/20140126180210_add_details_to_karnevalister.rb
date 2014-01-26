class AddDetailsToKarnevalister < ActiveRecord::Migration
  def change
    change_column :karnevalister, :google_token, :text, :limit => nil
    change_column :karnevalister, :utcheckad, :integer
  end
end
