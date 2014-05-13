# -*- encoding : utf-8 -*-
require "spec_helper"

describe Api::TrainPositionsController do


  describe "GET to APi::TrainPositionsController" do

    it "should return an array containing train positions" do
      p = FactoryGirl.create(:train_position, lat: 70.01, lng: -15.10)
      get :index, format: :json
      response.code.should eq("200")
      puts response.body
      response.body.should be_json_eql({ success: true, train_positions: [p] }.to_json)
    end

    it "should return no content if there are no positions" do
      get :index, format: :json
      response.code.should eq("204")
      response.body.should_not have_json_path("train_positions")
    end

  end

  describe "write operations" do
    before :each do
      request.env['devise.mapping'] = Devise.mappings[:user]
      @creds = {email: 'test@test.com', password: 'password', password_confirmation: 'password'}
      @user = FactoryGirl.create(:user, @creds)
      sign_in @user
    end

    describe "POST to Api::TrainPositionController" do

      it "should create a new train_pos if the user is authorized" do
        @user.roles << FactoryGirl.create(:role, name: "train_man")
        @user.save
        post :create, { token: @user.authentication_token, train_position: { lat:0, lng:0 } }, format: :json
        response.code.should eq("201")
        response.body['train_position'].should_not be_nil
        response.body.should have_json_path("train_position")
        TrainPosition.all.should_not be_empty
      end

      it "should not create a train_pos if the user is unathorized" do
        post :create, { token: @user.authentication_token, train_position: { lat:0, lng:0 } }, format: :json
        response.code.should eq("401")
        TrainPosition.all.should be_empty
      end

    end

    describe "PUT to API::TrainPositionsController with :id" do
      before { @p = FactoryGirl.create(:train_position, lat: 50.10, lng: 50.10) }
      it "update the train position lat and lng with id :id" do
        @user.roles << FactoryGirl.create(:role, name: "train_man")
        @user.save
        lat_before = @p.lat
        put :update, { token: @user.authentication_token, train_position: { lat: 35.17, lng: -137.50 }, id: @p.id }, format: :json
        response.code.should eq("200")
        response.body.should have_json_path("train_position")
        @p.reload
        lat_before.should_not eq(@p.lat)
      end

      it "should not update if the user is not authorized to" do
        @user.roles << FactoryGirl.create(:role, name: "train_man")
        @user.save
        lat_before = @p.lat
        put :update, { token: @user.authentication_token, train_position: { lat: 35.17, lng: -137.50 }, id: @p.id }, format: :json
        response.code.should eq("200")
        response.body.should have_json_path("train_position")
        lat_before.should eq(@p.lat)
      end

    end

  end

end
