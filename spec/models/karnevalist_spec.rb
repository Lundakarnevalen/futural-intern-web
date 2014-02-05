require 'spec_helper'

describe (K = Karnevalist) do
  def create_some_guy
    K.create :email => 'some@guy.com'
  end

  describe '.create' do
    it 'allows k. with only email' do
      K.create(:email => 'some@guy.com').errors.should be_empty
    end

    it 'disallows k. without email' do
      K.create(:email => nil, :fornamn => 'irrelevant').errors.should_not be_empty
    end

    it 'creates one and only one user with every karnevalist' do
      k = create_some_guy
      u = k.user
      u.should_not be_nil
      k.save
      k.user.should eq(u)
    end

    it 'does not expose the password in obvious ways' do
      id = create_some_guy().id
      K.find(id).password.should be_nil
    end

    it 'returns a valid password until it passes out of scope' do
      k = create_some_guy
      k.user.valid_password?(k.password).should be_true
    end

    it 'sets `utcheckad_at` if `utcheckad` is set for the first time' do
      k = create_some_guy
      k.utcheckad.should be_false
      k.utcheckad_at.should be_nil
      
      k.utcheckad = true
      k.save
      k.utcheckad.should be_true
      k.utcheckad_at.should_not be_nil
    end
  end

  describe '#save' do
    it 'syncs the user email and ensures password remains valid' do
      k = create_some_guy
      p = k.password
      k.email = 'some.other@guy.com'
      k.save
      k.user.email.should eq('some.other@guy.com')
      k.user.valid_password?(p).should be_true
    end
  end

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

  describe '#search' do
    def create_johan
      K.create :email => 'johan@forberg.se', :fornamn => 'Johan',
                         :efternamn => 'Förberg', :personnummer => '9110251817'
    end

    it 'performs simple matches' do
      create_johan
      K.search('johan').should_not be_empty
      K.search('förberg').should_not be_empty
      K.search('johan förberg').should_not be_empty
      K.search('91').should_not be_empty
    end

    it 'performs direct matches' do
      k = create_johan
      K.search(k.id.to_s).to_a.should eq([k])
    end

    it 'does not return false matches' do
      create_johan
      K.search('apa').should be_empty
      K.search('johann').should be_empty
      K.search('johan förberger').should be_empty
      K.search('9210251817').should be_empty
    end
  end
end
