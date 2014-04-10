require 'spec_helper'

describe Event do
  before{ @s = FactoryGirl.build :sektion }

  describe ' validations' do
    before{ @e = FactoryGirl.build :event }

    it 'can create event from reasonably values' do
      @e.should be_valid
    end
  end

  describe '.upcoming' do 
    it 'returns [] when approriate' do
      Event.upcoming.should be_empty
    end

    it 'returns events when appropriate' do
      e1 = FactoryGirl.create :event, :date => 10.days.ago 
      e2 = FactoryGirl.create :event, :date => 10.days.since
      e3 = FactoryGirl.create :event, :date => Date.today
      Event.upcoming.should eq([e2, e3])
    end
  end

  describe '.for_sektion' do
    before{ @s.save }

    it 'returns [] when appropriate' do
      Event.for_sektion(@s).should be_empty
    end

    it 'returns events when appropriate' do
      e1 = FactoryGirl.create :event, :sektion => @s
      e2 = FactoryGirl.create :event, :sektion => nil
      Event.for_sektion(@s).should eq([e1, e2])
    end
  end
end
