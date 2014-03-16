require 'spec_helper'

describe NotificationsController do
	before :each do
		@user = FactoryGirl.create(:user)
		sign_in @user
	end

	describe "GET to PhonesController" do
	end

	describe "GET with :id to PhonesController" do
	end

end