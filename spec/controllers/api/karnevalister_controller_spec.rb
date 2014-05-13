# -*- encoding : utf-8 -*-
require "spec_helper"

describe Api::KarnevalisterController do

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:user]
    @creds = {email: 'test@test.com', password: 'password', password_confirmation: 'password'}
    @user = FactoryGirl.create(:user, @creds)
    @id = @user.karnevalist.id
  end

  describe "PUT to api/karnevalister/:id" do


    it "should update ios_token if it is provided" do
      old_token = @user.karnevalist.ios_token
      new_token = "newtoken"
      put :update, {karnevalist: { ios_token: new_token}, id: @id, token: @user.authentication_token }, format: :json
      response.code.should eq("200")
      @user.reload
      @user.karnevalist.ios_token.should_not eq(old_token)
    end

    it "should ignore other params for karnevalist but accept google_token" do
      put :update, {karnevalist: { google_token: "test", tilldelad_sektion: 9000}, id: @id, token: @user.authentication_token }, format: :json
      @user.reload
      @user.karnevalist.tilldelad_sektion.should_not eq(9000)
      @user.karnevalist.google_token.should eq("test")
    end

    it "should update google_token if it is provided" do
      old_token = @user.karnevalist.google_token
      new_token = "newtoken"
      post :update, {karnevalist: {google_token: new_token }, id: @id, token: @user.authentication_token }, format: :json
      response.code.should eq("200")
      @user.reload
      @user.karnevalist.google_token.should_not eq(old_token)
    end
 end

  describe "fetch" do
    it "should return the karnevalist of the current user" do
      get :fetch, { token: @user.authentication_token }, format: :json
      response.code.should eq("200")
      response.body.should be_json_eql({ success: true, karnevalist: @user.karnevalist}.to_json)
    end

 end
end
