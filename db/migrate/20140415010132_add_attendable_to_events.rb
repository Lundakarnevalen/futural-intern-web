class AddAttendableToEvents < ActiveRecord::Migration
  def change
    add_column :events, :attendable, :boolean, :default => false
  end
end
