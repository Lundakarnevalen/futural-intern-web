require "spec_helper"

describe Api::ClustersController do
  before :each do
    request.env['devise.mapping'] = Devise.mappings[:user]
    @creds = {email: 'test@test.com', password: 'password', password_confirmation: 'password'}
    @user = FactoryGirl.create(:user, @creds)
    sign_in @user
  end

  describe "GET to APi::ClustersController" do

    it "should return an array containing clusters with quantity >= 10" do
      FactoryGirl.create(:cluster, lat: 70.01, lng: -15.10, quantity: 10)
      FactoryGirl.create(:cluster, lat: 70.01, lng: -15.10, quantity: 9)
      get :index, { token: @user.authentication_token }, format: :json
      response.code.should eq("200")
      response.body['clusters'].should_not be_nil
    end

    it "should return HTTP code not found if there are no clusters" do
      get :index, { token: @user.authentication_token }, format: :json
      response.code.should eq("204")
      response.body['clusters'].should be_nil
    end
  end

  describe "POST to Api::ClustersController" do
    it "should create a new cluster if no matches are found" do
      post :create, { token: @user.authentication_token, cluster: { lat:0, lng:0 } }, format: :json
      response.code.should eq("200")
      response.body['cluster_id'].should_not be_nil
      Cluster.all.should_not be_empty
    end

    it "should increament the quantity if the cordinates are within 5km" do
      c = FactoryGirl.create(:cluster, lat: 50.10, lng: 50.10)
      post :create, { token: @user.authentication_token, cluster: { lat:50.10, lng:50.10 } }, format: :json
      response.code.should eq("200")
      response.body['cluster_id'].should_not be_nil
      c.reload
      c.quantity.should eq(2)
    end

    it "should not increament if the cordinates are not within 5km" do
      c = FactoryGirl.create(:cluster, lat: 50.15, lng: -173.203)
      post :create, { token: @user.authentication_token, cluster: { lat:0, lng:0 } }, format: :json
      response.code.should eq("200")
      response.body['cluster_id'].should_not be_nil
      c.quantity.should_not eq(2)
    end

  end

  describe "PUT to API::ClustersController with :id" do
    describe "a cluster with quantity > 1" do
      before :each do
        @c = FactoryGirl.create(:cluster, lat: 50.10, lng: 50.10, quantity: 10)
      end

      it "should create a new cluster if no matches are found" do
        put :update, { token: @user.authentication_token, cluster: { lat: 35.17, lng: -137.50 }, id: @c.id }, format: :json
        response.code.should eq("200")
        response.body['cluster_id'].should_not be_nil
        Cluster.all.length.should eq(2)
      end

      it "should not increament the quantity if the cordinates are the same as previously" do
        put :update, { token: @user.authentication_token, cluster: { lat:50.10, lng:50.10 }, id: @c.id }, format: :json
        response.code.should eq("200")
        response.body['cluster_id'].should_not be_nil
        @c.reload
        @c.quantity.should eq(10)
      end

      it "should decrement the previous cluster if it is no longer included" do
        put :update, { token: @user.authentication_token, cluster: { lat: 15.15, lng: -35.52 }, id: @c.id }, format: :json
        response.code.should eq("200")
        response.body['cluster_id'].should_not be_nil
        @c.reload
        @c.quantity.should eq(9)
      end
    end

    it "should delete the previous cluster if quantity = 1" do
      c = FactoryGirl.create(:cluster, lat: 50.15, lng: -173.203, quantity: 1)
      id = c.id
      put :update, { token: @user.authentication_token, cluster: { lat: 15.15, lng: -35.52 }, id: id }, format: :json
      response.code.should eq("200")
      response.body['cluster_id'].should_not be_nil
      expect { Cluster.find(id) }.to raise_error
    end
  end

end
