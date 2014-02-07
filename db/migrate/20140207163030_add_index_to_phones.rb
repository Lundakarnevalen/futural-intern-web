class AddIndexToPhones < ActiveRecord::Migration
  def change
    add_index :phones, :google_token, unique: true
  end
end
