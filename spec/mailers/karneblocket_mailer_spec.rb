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
end
