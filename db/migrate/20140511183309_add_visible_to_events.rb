class AddVisibleToEvents < ActiveRecord::Migration
  def change
    add_column :events, :visible, :boolean, :default => true
  end
end
