class DropTicketListingSellingAttr < ActiveRecord::Migration
  def change
    remove_column :ticket_listings, :selling, :boolean
  end
end
