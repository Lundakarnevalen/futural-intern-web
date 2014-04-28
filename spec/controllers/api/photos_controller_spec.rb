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
      img = Rack::Test::UploadedFile.new('spec/fixtures/photos/test.jpg','image/jpg')
      post :create, { token: @user.authentication_token, photo: {image: img} }, format: :json
      response.code.should eq("201")
      response.body.should have_json_path("photo")
    end

    it "should return errors if an image is not present " do
      post :create, { token: @user.authentication_token, photo: {accepted: false} }, format: :json
      response.code.should eq("400")
      response.body.should have_json_path("errors")
    end

    it "should set official if the user is a photographer" do
      img = Rack::Test::UploadedFile.new('spec/fixtures/photos/test.jpg','image/jpg')
      @user.roles << FactoryGirl.create(:role, name: "photographer")
      post :create, { token: @user.authentication_token, photo: { image: img} }, format: :json
      response.code.should eq("201")
      response.body.should be_json_eql({ photo: Photo.all.first, success: true }.to_json)
    end
  end

end

