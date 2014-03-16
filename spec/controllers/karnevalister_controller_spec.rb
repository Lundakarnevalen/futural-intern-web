require 'spec_helper'

describe KarnevalisterController do
	before :each do
		@user = FactoryGirl.create(:user)
		sign_in @user
	end

	describe "GET to KarnvealistController" do
	  it "should be success for an admin" do
	    get :index
	    assigns(:karnevalister).should_not be_nil
	  end
	end

	describe "GET with :id to KarnvealistController" do
	  it "should return the karnevalist with id" do
	  end
	end

end