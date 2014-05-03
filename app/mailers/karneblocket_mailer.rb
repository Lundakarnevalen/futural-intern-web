# -*- encoding : utf-8 -*-
class KarneblocketMailer < ActionMailer::Base
  default :from => 'it@lundakarnevalen.se'

  def reminder listing
    @listing = listing
    mail :to => listing.seller.email,
         :subject => 'Din annons på Karneblocket'
  end

  def offer listing, message, customer
    @message = message
    @customer = customer
    @listing = listing

    mail :to => listing.seller.email,
         :reply_to => customer.email,
         :subject => "#{customer.fornamn} vill köpa biljetter av dig på Karneblocket"
  end

  def reminder_fail failures
    @failures = failures
    mail :to => 'system@lundakarnevalen.se',
         :subject => "Karneblocket reminder failures on #{Time.now.strftime '%Y-%m-%d'}"
  end

  def self.remind! listing
    self.reminder(listing).deliver
    listing.reminded!
  end
end
