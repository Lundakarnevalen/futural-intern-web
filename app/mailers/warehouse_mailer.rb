# -*- encoding : utf-8 -*-
class WarehouseMailer < ActionMailer::Base

  def notify_delivery(sender, receiver, subject, order)
    @order = order
    mail(to: receiver, subject: subject, from: sender)
  end
end
