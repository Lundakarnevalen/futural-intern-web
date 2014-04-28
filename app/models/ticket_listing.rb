class TicketListing < ActiveRecord::Base
  belongs_to :seller, :class_name => :Karnevalist
  belongs_to :event

  default_scope -> { order('created_at DESC') }
end
