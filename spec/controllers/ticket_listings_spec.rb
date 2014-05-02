require 'spec_helper'

describe TicketListingsController do
  describe 'ticket_listings#destroy' do
    before :each do 
      @k = FactoryGirl.create :karnevalist
      @tl = FactoryGirl.create :ticket_listing, :seller => @k,
                               :price => 100, :event => FactoryGirl.build(:event)
      @user = @k.user
    end

    # Token auth

    it 'allows destroy with correct token' do
      get :destroy, :id => @tl, :token => @tl.access_token
      response.should be_success
      response.should_not redirect_to :controller => :sessions
      TicketListing.exists?(@tl).should == false
    end

    it 'disallows destroy with bad token' do
      get :destroy, :id => @tl, :token => 'yomama123'
      response.should_not be_success
      TicketListing.exists?(@tl).should == true
    end

    it 'disallows destroy with missing token' do
      get :destroy, :id => @tl
      response.should_not be_success
      TicketListing.exists?(@tl).should == true
    end

    # Devise auth
    
    it 'allows destroy when authorized' do
      sign_in @user # that owns ticket listing

      delete :destroy, :id => @tl

      TicketListing.exists?(@tl).should == false
    end

    it 'does not allow random other actions' do
      get :show, :id => @tl
      response.should_not be_success
      response.should redirect_to '/users/sign_in'
    end
  end
end
