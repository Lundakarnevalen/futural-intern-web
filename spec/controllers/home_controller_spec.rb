# -*- encoding : utf-8 -*-
require 'spec_helper'
describe HomeController do
	describe "GET with to HomeController" do
	  it "should redirect if not signed in" do
	    get :index
	    response.should be_redirect
	    response.should redirect_to(new_user_session_path)
	  end
	  it "should not redirect if signed in" do
	  	@user = FactoryGirl.create(:user)
	  	sign_in @user
	    get :index
	    response.should_not be_redirect
	    response.should be_success
	  end
	end

  describe "GET to app store" do
    urls = {
      android: "market://details?id=se.lundakarnevalen.android",
      ios: "https://itunes.apple.com/se/app/karnevalisten/id811615995?mt=8"
    }

    it "should redirect to google play if user_agent = android" do
      request.env["HTTP_USER_AGENT"] = "Android"
      get :app_store
      response.should be_redirect
      response.should redirect_to(urls[:android])
    end

    it "should redirect to app store if user_agent = iphone" do
      request.env["HTTP_USER_AGENT"] = "iPhone"
      get :app_store
      response.should be_redirect
      response.should redirect_to(urls[:ios])
    end

    it "should render the view if user_agent = android|iphone" do
    end
  end

end
