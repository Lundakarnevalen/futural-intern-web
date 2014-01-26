class AddDetailsToKarnevalister < ActiveRecord::Migration
  def change
    change_column :karnevalister, :google_token, :text, :limit => nil
    change_column :karnevalister, :utcheckad, 'integer USING CAST(column_to_change AS integer)'
  end
end
