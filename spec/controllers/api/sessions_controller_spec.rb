require "spec_helper"
describe Api::SessionsController do
  describe "Session" do
    before :each do
      request.env['devise.mapping'] = Devise.mappings[:user]
      @creds = {email: 'test@test.com', password: 'password', password_confirmation: 'password'}
      @user = FactoryGirl.create(:user, @creds)
    end

    describe "POST to API::SessionController" do

      it "should sign in successfully and return authentication token" do
        post :create, {user: @creds }, format: :json
        response.code.should eq("200")
        controller.current_user.should_not be_nil
        controller.should be_signed_in
        response.body['token'].should_not be_nil
      end

      it "should sign in and return the karnevalist for the user" do
        post :create, { user: @creds }, format: :json
        response.code.should eq("200")
        response.body['karnevalist'].should_not be_nil
      end

      it "should return wrong email or password for invalid credentials or unfindable resources" do
        post :create, { user: {email: 'invalid@invalid.com', password: 'abc'}}, format: :json
        response.code.should eq("401")
        controller.current_user.should be_nil
        controller.should_not be_signed_in
        response.body['token'].should be_nil
      end

    end

    describe "signout" do
      it "should delete the token and sign out the user successfully" do
        sign_in @user
        delete :destroy, { auth_token: @user.authentication_token }, format: :json
        controller.current_user.should be_nil
        controller.should_not be_signed_in
        response.code.should eq("200")
      end

      it "should return error message if the token provided is not valid" do
        sign_in @user
        delete :destroy, {auth_token: "invalid" }, format: :json
        controller.current_user.should_not be_nil
        response.code.should eq("401")
      end

      it "should return error message if the toekn is not passed" do
        sign_in @user
        delete :destroy, :format => :json
        response.code.should eq("401")
        response.body['errors'].should_not be_nil
      end
    end

  end
end
