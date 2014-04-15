# -*- encoding : utf-8 -*-
class PodioSyncMailer < ActionMailer::Base
  default :from => 'it@lundakarnevalen.se'

  def sync_fail message
    @message = message
    mail :to => 'system@lundakarnevalen.se',
         :subject => "Podio sync failure on #{Time.now.strftime '%F'}"
  end
end
