require 'spec_helper'
describe HomeController do
	describe "GET with to HomeController" do
	  it "should redirect if not signed in" do
	    get :index
	    response.should be_redirect
	    response.should redirect_to(new_karnevalist_path)
	  end	
	end
end