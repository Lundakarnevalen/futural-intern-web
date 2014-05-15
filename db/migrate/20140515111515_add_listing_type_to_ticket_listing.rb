class AddListingTypeToTicketListing < ActiveRecord::Migration
  def change
    add_column :ticket_listings, :listing_type, :string
  end
end
