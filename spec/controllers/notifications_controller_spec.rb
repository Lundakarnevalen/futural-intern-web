require 'spec_helper'

describe NotificationsController do
	before :each do
		@user = FactoryGirl.create(:user)
		sign_in @user
	end

	describe "GET to NotificationsController" do
	end

	describe "GET with :id to NotificationsController" do
	end

end