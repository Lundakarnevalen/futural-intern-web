class RemoveMessageTypeFromNotifications < ActiveRecord::Migration
  def change
    remove_column :notifications, :message_type, :integer
  end
end
