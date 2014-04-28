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
  end

  describe '.ticket_events_for_karnevalist' do
    it 'returns [] when it should' do
      TicketListing.ticket_events_for_karnevalist(@k).should == []
    end

    it 'returns events when it should' do
      s = FactoryGirl.build(:sektion)
      @k.tilldelade_sektioner = [s]
      @e.sektion = s
      @e.save
      e1 = FactoryGirl.create :event, :sektion => nil, :tickets => true
      e2 = FactoryGirl.create :event, :sektion => FactoryGirl.build(:sektion),
        :tickets => false
      TicketListing.ticket_events_for_karnevalist(@k)
        .should match_array [@e, e1]
    end
  end
end

