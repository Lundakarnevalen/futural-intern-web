# -*- encoding: utf-8 -*-
class TicketListing < ActiveRecord::Base
  belongs_to :seller, :class_name => Karnevalist
  belongs_to :event

  default_scope -> { order('created_at DESC') }

  validates :seller, :presence => true
  validates :event, :presence => true
  validates :price, :numericality => 
                      { :message => 'Måste vara ett helt antal kronor' },
                    :inclusion => 
                      { :in => 1..1000, 
                        :message => 'Priset ser lite misstänkt ut' } 

  validate do # event
    if event.present? && !event.tickets?
      errors.add :event, 'Händelsen verkar inte stödja biljetter'
    end
  end

  def self.ticket_events_for_karnevalist k
    Event.upcoming.with_tickets.for_sektioner k.tilldelade_sektioner
  end
end
