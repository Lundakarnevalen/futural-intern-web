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

    it 'creates a user with every new karnevalist' do
      create_some_guy().user.should_not be_nil
    end

    it 'does not expose the password in obvious ways' do
      id = create_some_guy().id
      K.find(id).password.should be_nil
    end

    it 'returns a valid password until it passes out of scope' do
      k = create_some_guy
      k.user.valid_password?(k.password).should be_true
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
end
