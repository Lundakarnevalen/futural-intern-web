class CreateTicketListings < ActiveRecord::Migration
  def change
    create_table :ticket_listings do |t|
      t.text :description
      t.integer :price
      t.boolean :selling, :default => true # true: sell, false: trade
      t.integer :seller_id
      t.integer :event_id
      t.timestamps
    end
  end
end
