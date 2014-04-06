require 'spec_helper'

describe NotificationsController do

	before :each do
		@user = FactoryGirl.create(:user)
    @user.roles << FactoryGirl.create(:role, name: "admin")
    @user.save
		sign_in @user
		@note = FactoryGirl.create(:notification)
	end

	describe "GET to NotificationsController" do
	  it "should assign notifications where recipient_id = 0" do
	    get :index
	    assigns(:notifications).should_not be_nil
	    assigns(:notifications).should eq([@note])
	    response.should be_success
	  end

	  it "should permit blank options" do
	  	get :index, format: :json, notification: {}
	  end

    it "should permit non blank options" do
      get :index, format: :json, notification: {title: "hello", message: "hello"}
      response.should be_success
    end

    it "should permit unknown fields" do
      get :index, format: :json, notification: {unknown: "abc"}
    end

	end

	describe "GET to NotificationsController with :id" do
		it "should return the notification with :id" do
			get :show, id: @note.id
			assigns(:notification).should eq(@note)
			response.should be_success
		end
	end

  describe "POST to NotificationsController" do
    it "should create a new notification" do
      post :create, notification: {title: "abc123", message: "hello"}
      response.should redirect_to(notifications_path)
      Notification.where(title: "abc123").should exist
    end
    it "should throw err if there are invalid params" do
      expect { post :create, notification: {unknown: "title", message: "unknown"} }.to raise_error
    end
  end
end
