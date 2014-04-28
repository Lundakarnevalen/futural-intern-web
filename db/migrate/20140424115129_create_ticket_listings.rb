class CreateTicketListings < ActiveRecord::Migration
  def change
    create_table :ticket_listings do |t|

      t.timestamps
    end
  end
end
