# -*- encoding : utf-8 -*-
require "spec_helper"

describe Api::PhotosController do
 before :each do
    request.env['devise.mapping'] = Devise.mappings[:user]
    @creds = {email: 'test@test.com', password: 'password', password_confirmation: 'password'}
    @user = FactoryGirl.create(:user, @creds)
    sign_in @user
  end

  describe "GET to APi::PhotosController" do

    it "should return an array containing photos" do
      p = FactoryGirl.create(:photo)
      get :index, { token: @user.authentication_token }, format: :json
      response.code.should eq("200")
      response.body.should be_json_eql({photos: [p], success: true}.to_json)
    end
  end

  describe "POST to Api::PhotosController" do
    it "should create a new photo" do
    end
  end

  describe "PUT to API::PhotosController with :id" do
  end
end

