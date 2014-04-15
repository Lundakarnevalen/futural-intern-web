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
      Event.upcoming.should match_array [e2, e3]
    end
  end

  describe '.for_sektioner' do
    before{ @s.save }

    it 'returns [] when appropriate' do
      Event.for_sektioner([]).should be_empty
      Event.for_sektioner([@s]).should be_empty
    end

    it 'returns events when appropriate, one sektion' do
      e1 = FactoryGirl.create :event, :sektion => @s
      e2 = FactoryGirl.create :event, :sektion => nil
      Event.for_sektioner([@s]).should eq([e1, e2])
    end

    it 'returns events when appropriate, several sektion' do
      s2 = FactoryGirl.create :sektion
      e1 = FactoryGirl.create :event, :sektion => @s
      e2 = FactoryGirl.create :event, :sektion => s2
      Event.for_sektioner([@s, s2]).should eq([e1, e2])
    end
  end

  describe '#attending?' do
    before do
      @k = FactoryGirl.build :karnevalist
      @e = FactoryGirl.build :event
      @a = FactoryGirl.build :attendance, :event => @e, :karnevalist => @k
    end
    
    it 'returns false when it should' do 
      @e.attending?(@k).should == false
    end

    it 'returns false for nil' do
      @e.attending?(nil).should == false
    end

    it 'returns true when it should' do 
      @a.save
      @e.attending?(@k).should == true
    end
  end
end
