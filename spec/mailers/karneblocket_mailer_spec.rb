require 'spec_helper'

describe KarneblocketMailer do
  before do
    @k = FactoryGirl.build :karnevalist
    @e = FactoryGirl.build :event
    @tl = FactoryGirl.create :ticket_listing, :event => @e,
                             :seller => @k, :last_reminder => 10.days.ago
  end

  describe '#reminder' do
    before do
      @mail = KarneblocketMailer.reminder @tl
    end

    it 'sets the correct recipient' do
      @mail.to.should == [ @k.email ]
    end

    it 'sets a message including the relevant facts' do
      @mail.body.should include @tl.link_to_destroy
      @mail.body.should include @tl.event.title
    end
  end

  describe '#remind!' do
    it 'sends the email' do
      KarneblocketMailer.remind! @tl
      ActionMailer::Base.deliveries.last.should == KarneblocketMailer.reminder(@tl)
    end

    it 'updates the reminded status of the listing' do
      KarneblocketMailer.remind! @tl
      @tl.last_reminder.should be_within(1.second).of DateTime.now
    end
  end

  describe '#reminder_fail' do
    before do
      tl = TicketListing.new :seller => (Karnevalist.new :email => 'johan@forberg.se')
      @mail = KarneblocketMailer.reminder_fail(
        tl => RuntimeError.new('Shit went down'))
    end

    it 'sets the correct recipient' do
      @mail.to.should == [ 'system@lundakarnevalen.se' ]
    end

    it 'sets a message including relevant shit' do
      @mail.body.should include 'Shit went down'
      @mail.body.should include 'RuntimeError'
      @mail.body.should include 'johan@forberg.se'
    end
  end

  describe '#offer' do
    before do 
      @customer = FactoryGirl.build :karnevalist
      @message = 'Jag köper skiten, sitter här hemma och är festsugen som fan.'
      @mail = KarneblocketMailer.offer @tl, @message, @customer
    end

    it 'sets the correct recipient' do
      @mail.to.should == [@tl.seller.email]
    end

    it 'sets the correct reply-to' do
      @mail.reply_to.should == [@customer.email]
    end

    it 'sets a body including relevant information' do
      @mail.body.should include @customer.fornamn
      @mail.body.should include @customer.email
      @mail.body.should include @tl.event.title
      @mail.body.should include @message
      @mail.body.should include @tl.link_to_destroy
    end
  end
end
