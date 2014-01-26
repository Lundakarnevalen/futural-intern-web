class AddDetailsToNotifications < ActiveRecord::Migration
  def change
    remove_column :notifications, :text, :text
    add_column :notifications, :title, :string
    add_column :notifications, :message, :text
    add_column :notifications, :message_type, :integer
  end
end
