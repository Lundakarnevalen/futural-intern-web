# -*- encoding : utf-8 -*-
class KarneblocketMailer < ActionMailer::Base
  default :from => 'it@lundakarnevalen.se'

  def send_reminder listing
    @message = <<eof
Hej!

Du lade ut en annons på karneblocket för några dagar sedan, angående 
biljetter till eventet "#{listing.event.title}". 

Har du fått sålt dina biljetter ännu? Klicka i så fall på länken här:

#{listing.link_to_destroy}

Annars behöver du inte göra något, vi önskar dig lycka till helt enkelt!

Mvh

IT/System, Lundakarnevalen
eof
  mail :to => listing.seller.email,
       :subject => 'Din annons på Karneblocket'
  end
end
