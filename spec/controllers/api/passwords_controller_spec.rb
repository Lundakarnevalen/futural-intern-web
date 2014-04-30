# -*- encoding : utf-8 -*-
require "spec_helper"

describe Api::PasswordsController do
  describe "POST to Api::PasswordsController" do
    before :each do
      request.env['devise.mapping'] = Devise.mappings[:user]
      @creds = {email: 'test@test.com', password: 'password', password_confirmation: 'password'}
      @user = FactoryGirl.create(:user, @creds)
    end

    it "should send reset password request" do
      post :create, {user: {email: 'test@test.com'}}, format: :json
      response.code.should eq("200")
    end

    it "should return error message if invalid user" do
      post :create, {user: {email: 'abc@abc.com'}}, format: :json
      response.code.should eq("422")
    end
 end
end
