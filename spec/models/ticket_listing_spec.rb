require 'spec_helper'

describe TicketListing do
  before do
    @e = FactoryGirl.build :event,
      :tickets => true
    @k = FactoryGirl.build :karnevalist
    @tl = FactoryGirl.build :ticket_listing,
      :event => @e, :seller => @k
  end

  describe ' validations' do
    it 'can create a ticket listing from reasonable values' do
      @tl.should be_valid
    end

    it 'rejects listing for event that does not have tickets' do
      @e.tickets = false
      @tl.event = @e
      @tl.should_not be_valid
    end

    it 'rejects listing with no event' do
      @tl.event = nil
      @tl.should_not be_valid
    end

    it 'rejects listing with no seller' do
      @tl.seller = nil
      @tl.should_not be_valid
    end

    it 'rejects listing with suspect price' do
      @tl.price = 10000000000
      @tl.should_not be_valid

      @tl.price = 'Hehe'
      @tl.should_not be_valid
    end
  end

  describe '.ticket_events_for_karnevalist' do
    it 'returns [] when it should' do
      TicketListing.ticket_events_for_karnevalist(@k).should == []
    end

    it 'returns events when it should' do
      s = FactoryGirl.create(:sektion)
      @k.tilldelade_sektioner = [s]
      @e.sektion = s
      @e.save
      e1 = FactoryGirl.create :event, :sektion => nil, :tickets => true
      e2 = FactoryGirl.create :event, :sektion => FactoryGirl.build(:sektion),
        :tickets => true
      TicketListing.ticket_events_for_karnevalist(@k)
        .should match_array [@e, e1]
    end
  end

  describe '.to_remind' do
    before do
      @tl1 = FactoryGirl.build :ticket_listing, :seller => @k,
                               :event => @e
      @tl2 = FactoryGirl.build :ticket_listing, :seller => @k,
                               :event => @e
    end

    it 'returns empty when it should' do
      @tl1.last_reminder = 1.days.ago
      @tl1.created_at = 10.days.ago
      @tl1.save
      
      @tl2.created_at = 3.days.ago
      @tl2.save
      TicketListing.to_remind.should == []
    end

    it 'returns listings when it should' do
      @tl1.created_at = 10.days.ago
      @tl1.save
      
      @tl2.last_reminder = 6.days.ago
      @tl2.save

      TicketListing.to_remind.should match_array [@tl1, @tl2]
    end
  end

  describe '#link_to_destroy' do
    before do
      @tl = FactoryGirl.build :ticket_listing, :event => @e, :seller => @k
    end

    it 'fails if not saved' do
      -> { @tl.link_to_destroy }.should raise_exception
    end

    it 'returns correct link' do
      @tl.save
      @tl.link_to_destroy.should ==
        "http://karnevalist.se/ticket_listings/#{@tl.id}/destroy?token=#{@tl.access_token}"
    end
  end
end

