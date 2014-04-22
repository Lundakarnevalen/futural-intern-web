# -*- encoding : utf-8 -*-
require 'spec_helper'
describe WarehouseMailer do
  before(:each) do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    @order = FactoryGirl.create(:order)
    @from = 'from@test.com'
    @to = 'to@test.com'
    WarehouseMailer.notify_delivery(@from, @to , 'test', @order).deliver
  end

  after(:each) do
    ActionMailer::Base.deliveries.clear
  end

   it 'should send an email' do
    ActionMailer::Base.deliveries.count.should eq(1)
  end

  it 'renders the receiver email' do
    ActionMailer::Base.deliveries.first.to.should eq([@to])
  end

   it 'should set the subject' do
    ActionMailer::Base.deliveries.first.subject.should eq('test')
  end

  it 'renders the sender email' do
    ActionMailer::Base.deliveries.first.from.should eq([@from])
  end


end
