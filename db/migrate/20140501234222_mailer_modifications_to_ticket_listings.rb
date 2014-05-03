class MailerModificationsToTicketListings < ActiveRecord::Migration
  def change
    add_column :ticket_listings, :last_reminder, :datetime
    add_column :ticket_listings, :access_token, :string
  end
end
