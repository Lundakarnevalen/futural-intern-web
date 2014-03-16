require 'spec_helper'

describe NotificationsController do

	before :each do
		@user = FactoryGirl.create(:user)
		sign_in @user
		@note = FactoryGirl.create(:notification)
	end

	describe "GET to NotificationsController" do
	  it "should assign all notifications" do
	    get :index
	    assigns(:notifications).should_not be_nil
	    assigns(:notifications).should eq([@note])
	    response.should be_success
	  end

	  it "should throw error since doesn't permit blank options" do
	  	expect { get :index, format: :json, notification: {} }.to raise_error
	  end
	end

	describe "GET to NotificationsController with :id" do
		it "should return the notification with :id" do
			get :show, id: @note.id
			assigns(:notification).should eq(@note)
			response.should be_success
		end
	end

end
