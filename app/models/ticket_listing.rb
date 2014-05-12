# -*- encoding: utf-8 -*-

require 'securerandom'

class TicketListing < ActiveRecord::Base
  belongs_to :seller, :class_name => Karnevalist
  belongs_to :event

  validates :seller, :presence => true
  validates :event, :presence => true
  validates :price, :presence => true,
                    :numericality =>
                      { :message => 'Måste vara ett helt antal kronor' },
                    :inclusion =>
                      { :in => 1..1000,
                        :message => 'Priset ser lite misstänkt ut' }

  scope :event_id, -> (event_id) { where event_id: event_id }
  scope :selling, -> (selling) { where selling: (selling == 'true') }
  scope :seller_id, -> (seller_id) { where seller_id: seller_id }

  validate do # event
    if event.present? && !event.tickets?
      errors.add :event, 'Händelsen verkar inte stödja biljetter'
    end
  end

  before_save do
    self.access_token ||= SecureRandom.urlsafe_base64(32)
  end

  def reminded!
    self.update_attributes :last_reminder => Time.now
  end

  def link_to_destroy
    if self.new_record?
      fail ArgumentError, "Can't destroy record that has not been saved."
    end
    Rails.application.routes.url_helpers.destroy_ticket_listing_url(self,
      :token => self.access_token, :host => 'karnevalist.se')
  end

  def self.ticket_events_for_karnevalist k
    Event.upcoming.with_tickets.for_sektioner k.tilldelade_sektioner
  end

  def self.to_remind
    self.where 'last_reminder <= ? or (last_reminder is null and created_at <= ?)',
               5.days.ago, 5.days.ago
  end
end
