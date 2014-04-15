# -*- encoding : utf-8 -*-
require 'spec_helper'

describe SektionerController do
  before :each do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  describe "GET to SektionerController" do
  	before :each do
  		@sektion = FactoryGirl.create(:sektion) 
  	end

    it "should return all sektioner if the user is admin" do
    	@user.roles << FactoryGirl.create(:role, name: "admin")
    	@user.save
    	s = FactoryGirl.create(:sektion, name: "test")
      get :index       
      response.should be_success
      assigns(:sektioner).should_not be_nil
      assigns(:sektioner).to_a.should eql([@sektion, s])
    end 
=begin
    it "should return sektions which the current user sektionsadmin " do
    	@user.roles << FactoryGirl.create(:role, name: "sektionsadmin")
    	get :index	
      assigns(:sektioner).should_not be_nil
      assigns(:sektioner).should eql([@user.sektioner])
    end
=end
  end
end
