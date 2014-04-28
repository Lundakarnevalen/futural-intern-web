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

    it "should return an array containing photos which are not accepted yet" do
      p = FactoryGirl.create(:photo, accepted: false)
      get :index
      assigns(:photos).should_not be_nil
    end

    it "should not contain photos which have been accepted" do
      p_n = FactoryGirl.create(:photo, accepted: false)
      p_a = FactoryGirl.create(:photo, accepted: true)
      get :index
      assigns(:photos).should eq([p_n])
      assigns(:photos).should_not eq([p_n, p_a])
    end
  end

  describe "update" do
    it "should update the photo and set it to accepted" do
    end
  end
  describe "delete" do
    it "should delete the photo if it is not accepted" do
    end
  end
end

