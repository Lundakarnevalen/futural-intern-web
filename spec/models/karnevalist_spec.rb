# -*- encoding : utf-8 -*-
require 'spec_helper'

describe (K = Karnevalist) do

  before { @karnevalist = FactoryGirl.create(:karnevalist) }

  describe '.create' do
    it 'allows k. with only email' do
      FactoryGirl.build(:karnevalist, email: 'some@guy.com').should be_valid
    end

    it 'disallows k. without email' do
      FactoryGirl.build(:karnevalist, email: nil, fornamn: 'irrelevant').should_not be_valid
    end

    it 'creates one and only one user with every karnevalist' do
      user = @karnevalist.user
      @karnevalist.user.should eq(user)
    end

    it 'does not expose the password in obvious ways' do
      id = @karnevalist.id
      K.find(id).password.should be_nil
    end

    it 'returns a valid password until it passes out of scope' do
      k = @karnevalist
      k.user.valid_password?(k.password).should be_true
    end

    it 'sets `utcheckad_at` if `utcheckad` is set for the first time' do
      @karnevalist.utcheckad.should be_false
      @karnevalist.utcheckad_at.should be_nil

      @karnevalist.utcheckad = true
      @karnevalist.save
      @karnevalist.utcheckad.should be_true
      @karnevalist.utcheckad_at.should_not be_nil
    end

    # Personnummer
    it 'allows missing `personnummer`' do
      FactoryGirl.build(:karnevalist, :personnummer => nil)
                 .should be_valid
    end

    it 'allow proper `personnummer`' do
      FactoryGirl.build(:karnevalist, :personnummer => '1111111116')
                 .should be_valid
    end

    it 'rejects invalid `personnummer` checksum' do
      FactoryGirl.build(:karnevalist, :personnummer => '1111111111')
                 .should_not be_valid
    end

    it 'rejects invalid `personnummer` dates' do
      # This number's checksum is actually valid!
      FactoryGirl.build(:karnevalist, :personnummer => '999999-9999')
                 .should_not be_valid
    end

    it 'allows "international" `personnummer`' do
      FactoryGirl.build(:karnevalist, :personnummer => '911025-P123')
                 .should be_valid
    end

    it 'allows empty sektioner' do
      k = FactoryGirl.build :karnevalist
      k.tilldelade_sektioner = []
      k.should be_valid
    end

    it 'rejects if `sektion` == `sektion2`' do
      s = FactoryGirl.build :sektion
      k = FactoryGirl.build(:karnevalist, :sektion => s, :sektion2 => s)
                     .should_not be_valid
    end

    it 'checks that tilldelad_sektion actually exists' do
      # This caused a great deal of trouble.
      k = FactoryGirl.build(:karnevalist)
      k.assign_attributes(:tilldelad_sektion => -123123)
      k.should_not be_valid
    end
  end

  describe '#save' do
    it 'syncs the user email and ensures password remains valid' do
      @karnevalist.email = 'some.other@guy.com'
      @karnevalist.save
      @karnevalist.user.email.should eq('some.other@guy.com')
      @karnevalist.user.valid_password?(@karnevalist.password).should be_true
    end

    it 'sets utcheckad if tilldelade_sektioner.any?' do
      s = FactoryGirl.create :sektion
      k = FactoryGirl.build :karnevalist
      k.tilldelade_sektioner = [s]
      k.save
      k.tilldelade_sektioner.should_not be_empty
      k.utcheckad.should be_true
    end
  end

  describe '.search' do
    before :each do
      @k = FactoryGirl.create(:karnevalist, email: "johan@forberg.se", fornamn: "johan",
        efternamn: "Förberg", personnummer: "9110251817")
    end

    it 'performs simple matches' do
      K.search('johan').should_not be_empty
      K.search('förberg').should_not be_empty
      K.search('johan förberg').should_not be_empty
      K.search('91').should_not be_empty
    end

    it 'performs direct matches' do
      K.search(@k.id.to_s).to_a.should eq([@k])
    end

    it 'does not return false matches' do
      K.search('apa').should be_empty
      K.search('johann').should be_empty
      K.search('johan förberger').should be_empty
      K.search('9210251817').should be_empty
    end

    it 'can search for email' do
      K.search('johan@forberg.se').should_not be_empty
    end
  end

  describe '#tilldelade_sektioner' do
    before :each do
      @k = FactoryGirl.build :karnevalist,
                             :sektion => nil,
                             :sektion2 => nil
      @s1 = FactoryGirl.build :sektion, :name => 'Sekt1'
      @s2 = FactoryGirl.build :sektion, :name => 'Sekt2'
    end

    it 'handles case of no `sektion`' do
      @k.tilldelade_sektioner.should be_empty
    end

    it 'handles case of single primary `sektion`' do
      @k.sektion = @s1
      @k.tilldelade_sektioner.should eq [@s1]
    end

    it 'handles case of two `sektion`' do
      @k.assign_attributes :sektion => @s1,
                           :sektion2 => @s2
      @k.tilldelade_sektioner.should eq [@s1, @s2]
    end
  end

  describe '#tilldelade_sektioner=' do
    before :each do
      @k = FactoryGirl.build :karnevalist,
                             :sektion => nil,
                             :sektion2 => nil
      @s1 = FactoryGirl.build :sektion, :name => 'Sekt1'
      @s2 = FactoryGirl.build :sektion, :name => 'Sekt2'
    end

    it 'handles the empty case' do
      @k.tilldelade_sektioner = []
      @k.tilldelade_sektioner.should be_empty
      @k.sektion.should be_nil
      @k.sektion2.should be_nil
    end

    it 'handles the singular case' do
      @k.tilldelade_sektioner = [@s1]
      @k.tilldelade_sektioner.should eq [@s1]
      @k.sektion.should eq @s1
      @k.sektion2.should be_nil
    end

    it 'handles the general case' do
      @k.tilldelade_sektioner = [@s2, @s1]
      @k.tilldelade_sektioner.should eq [@s2, @s1]
      @k.sektion.should eq @s2
      @k.sektion2.should eq @s1
    end
  end
end
