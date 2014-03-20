require 'spec_helper'

describe PhonesController do
  before :each do
    @user = FactoryGirl.create(:user)
    @user.roles << FactoryGirl.create(:role, name: "admin")
    @user.save
    sign_in @user
  end

  describe "POST to PhonesController" do
    it "should create a new phone" do
      t = "googletoken"
      post :create, phone: {google_token: t}, format: :json
      response.should be_success
      response.body.should be_json_eql({status: "success", id: 1}.to_json)
      Phone.where(google_token: t).should exist
    end 

    it "should throw err if invalid params are sent" do
      expect { post :create, phone: {invalid_params: "invalid"}, format: :json }.to raise_error
    end
  end
end