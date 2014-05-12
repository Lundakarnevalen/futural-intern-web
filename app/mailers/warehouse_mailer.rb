# -*- encoding : utf-8 -*-
class WarehouseMailer < ActionMailer::Base
  add_template_helper(Warehouse::ApplicationHelper)

  def notify_delivery(sender, receiver, subject, order, warehouse_code)
    @order = order
    @warehouse_code = warehouse_code
    mail(to: receiver, subject: subject, from: sender)
  end

  def new_order(sender, receiver, subject, order, warehouse_code)
    @order = order
    @warehouse_code = warehouse_code
    mail(to: receiver, subject: subject, from: sender)
  end
end
