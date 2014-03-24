require 'spec_helper'

describe (K = Karnevalist) do

  describe '.create' do
    it 'allows k. with only email' do
      FactoryGirl.build(:karnevalist, email: 'some@guy.com').should be_valid
    end

    it 'disallows k. without email' do
      FactoryGirl.build(:karnevalist, email: nil, fornamn: 'irrelevant').should_not be_valid 
    end

    it 'creates one and only one user with every karnevalist' do
      k = FactoryGirl.create(:karnevalist)
      u = k.user
      k.user.should eq(u)
    end

    it 'does not expose the password in obvious ways' do
      id = FactoryGirl.create(:karnevalist).id
      K.find(id).password.should be_nil
    end

    it 'returns a valid password until it passes out of scope' do
      k = FactoryGirl.create(:karnevalist) 
      k.user.valid_password?(k.password).should be_true
    end

    it 'sets `utcheckad_at` if `utcheckad` is set for the first time' do
      k = FactoryGirl.create(:karnevalist) 
      k.utcheckad.should be_false
      k.utcheckad_at.should be_nil
      
      k.utcheckad = true
      k.save
      k.utcheckad.should be_true
      k.utcheckad_at.should_not be_nil
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
  end

  describe '#save' do
    it 'syncs the user email and ensures password remains valid' do
      k = FactoryGirl.create(:karnevalist)
      p = k.password
      k.email = 'some.other@guy.com'
      k.save
      k.user.email.should eq('some.other@guy.com')
      k.user.valid_password?(p).should be_true
    end
  end

=begin
  describe '#update_if_password_valid' do
    it 'updates if password valid' do
      k = create_some_guy
      p = k.password
      k.update_if_password_valid({'token' => p, 
                                  'email' => 'some.other@guy.com'})
      k.errors.should be_empty
      k.email.should eq('some.other@guy.com')
    end

    it 'does not update if password not valid' do
      k = create_some_guy
      k.update_if_password_valid({'token' => 'invalid',
                                  'email' => 'some.other@guy.com'})
      k.errors.should_not be_empty
      k.email.should eq('some@guy.com')
    end
  end
=end

  describe '#search' do
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
end
