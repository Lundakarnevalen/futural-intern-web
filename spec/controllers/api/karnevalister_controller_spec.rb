require "spec_helper"

describe Api::KarnevalisterController do
  describe "PUT to api/karnevalister/:id" do
    before :each do
      request.env['devise.mapping'] = Devise.mappings[:user]
      @creds = {email: 'test@test.com', password: 'password', password_confirmation: 'password'}
      @user = FactoryGirl.create(:user, @creds)
      @id = @user.karnevalist.id
    end

    it "should update ios_token if it is provided" do
      old_token = @user.karnevalist.ios_token
      new_token = "newtoken"
      put :update, {karnevalist: { ios_token: new_token}, id: @id, token: @user.authentication_token }, format: :json
      response.code.should eq("200")
      @user.reload
      @user.karnevalist.ios_token.should_not eq(old_token)
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
end
