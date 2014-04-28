class AddTicketsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :tickets, :boolean
  end
end
