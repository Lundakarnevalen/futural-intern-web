class AddStringsToTicketListings < ActiveRecord::Migration
  def change
    add_column :ticket_listings, :title, :string
    add_column :ticket_listings, :description, :string
  end
end
