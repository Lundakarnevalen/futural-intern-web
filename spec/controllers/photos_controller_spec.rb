# -*- encoding : utf-8 -*-
require "spec_helper"

describe PhotosController do
 before :each do
    request.env['devise.mapping'] = Devise.mappings[:user]
    @creds = {email: 'test@test.com', password: 'password', password_confirmation: 'password'}
    @user = FactoryGirl.create(:user, @creds)
    @user.roles << FactoryGirl.create(:role, name: "photographer")
    sign_in @user
  end

  describe "index" do

  end

  describe "white list" do

    it "should return an array containing photos which are not accepted yet" do
      p = FactoryGirl.create(:photo, accepted: false)
      get :white_list
      assigns(:photos).should_not be_nil
    end

    it "should not contain photos which have been accepted" do
      p_n = FactoryGirl.create(:photo, accepted: false)
      p_a = FactoryGirl.create(:photo, accepted: true)
      get :white_list
      assigns(:photos).should eq([p_n])
      assigns(:photos).should_not eq([p_n, p_a])
    end
  end

  describe "update" do
    it "should update the photo and set it to accepted" do
    end
  end

  describe "create" do
    it "should create a new photo" do
      img = Rack::Test::UploadedFile.new('spec/fixtures/photos/test.jpg','image/jpg')
      post :create, {photo: {image: img, karnevalist_id: @user.karnevalist.id } }
      response.should be_redirect
      response.should redirect_to action: :index
    end
  end
  describe "delete" do
    it "should delete the photo if it is not accepted" do
    end
  end
end

