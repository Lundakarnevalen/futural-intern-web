# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Attendance do
  before do
    @k = FactoryGirl.build :karnevalist
    @e = FactoryGirl.build :event
    @a = FactoryGirl.build :attendance, :event => @e, :karnevalist => @k
  end

  describe '#valid?' do
    it 'should allow reasonable values' do
      @a.should be_valid
    end

    it 'should disallow missing event, karnevalist' do
      @a.assign_attributes :event => nil, :karnevalist => nil
      @a.should_not be_valid
    end

    it 'should disallow attending events in the past' do
      @e.date = 10.days.ago
      @a.event = @e
      @a.should_not be_valid
    end

    it 'should disallow attending non-attendable event' do
      @e.attendable = false
      @a.event = @e
      @a.should_not be_valid
    end
  end

  describe '.create_or_update' do
    it 'should create attendance if no current' do
      @k.save
      @e.save
      @e.attendances.should == []
      a = Attendance.create_or_update :event => @e, :karnevalist => @k
      @e.reload.attendances.should == [a]
    end

    it 'should replace existing attendance if any' do
      @a.save
      @e.attendances.should == [@a]
      @a2 = Attendance.create_or_update :comment => 'Allergic to something else',
                                        :event => @e, :karnevalist => @k
      @e.attendances.should == [@a2]
      @a.id.should == @a2.id
    end
  end

  describe '.existing_or_new' do 
    before do
      @e.save
      @k.save
    end

    it 'should return existing when there is' do
      @a.save
      (a = Attendance.existing_or_new(:event => @e, :karnevalist => @k))
                    .should == @a
      a.new_record?.should == false

    end

    it 'should return new when no existing' do
      Attendance.existing_or_new(:event => @e, :karnevalist => @k)
                .new_record?.should == true
    end
  end
end

