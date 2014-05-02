# -*- encoding : utf-8 -*-
class KarneblocketMailer < ActionMailer::Base
  default :from => 'it@lundakarnevalen.se'

  def reminder listing
    @listing = listing
    mail :to => listing.seller.email,
         :subject => 'Din annons på Karneblocket'
  end

  def self.remind! listing
    self.reminder(listing).deliver
    listing.reminded!
  end
end
