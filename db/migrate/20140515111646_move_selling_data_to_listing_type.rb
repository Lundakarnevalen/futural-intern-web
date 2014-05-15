class MoveSellingDataToListingType < ActiveRecord::Migration
  def up
    TicketListing.all.each do |listing|
      if listing.selling
        listing.listing_type = 'sälja'
      else
        listing.listing_type = 'byta'
      end
      listing.save
    end
  end

  def down
    TicketListing.all.each do |listing|
      if listing.listing_type == 'sälja'
        listing.selling = true
      else
        listing.selling = false
      end
      listing.save
    end
  end
end
