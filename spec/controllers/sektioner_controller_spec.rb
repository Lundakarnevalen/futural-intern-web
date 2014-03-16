require 'spec_helper'

describe SektionerController do
	before :each do
		@user = FactoryGirl.create(:user)
		sign_in @user
	end

	describe "GET to KarnvealistController" do
	  it "should be successfull" do
	  	get :index
	  end
	end

	describe "GET with :id to KarnvealistController" do
	  it "should return the karnevalist with id" do
	  end
	end

end