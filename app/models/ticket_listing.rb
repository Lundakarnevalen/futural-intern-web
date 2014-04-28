# -*- encoding: utf-8 -*-
class TicketListing < ActiveRecord::Base
  belongs_to :seller, :class_name => Karnevalist
  belongs_to :event

  default_scope -> { order('created_at DESC') }

  validate :seller, :presence => true
  validate :event, :presence => true
  validate :price, :numericality => 
                     { :message => 'Måste vara ett helt antal kronor' },
                   :inclusion => 
                     { :range => 1..1000, 
                       :message => 'Priset ser lite misstänkt ut' } 

  validate do # event
    if event.present? && !event.tickets?
      errors.add :event, 'Händelsen verkar inte ha några biljetter... Fel?'
    end
  end

  def self.ticket_events_for_karnevalist k
    Event.upcoming.with_tickets.for_sektioner k.tilldelade_sektioner
  end
end
