require 'spec_helper'

describe Warehouse::OrdersController do

  before :each do
    @user = FactoryGirl.create(:user)
    sign_in @user
    @order = FactoryGirl.create(:order)
  end

  describe "GET to OrdersController" do
    it "Should show all orders" do
      get :index
      assigns(:orders).should_not be_nil
      assigns(:orders).should eq([@order])
      response.should be_success
    end
  end

  describe "GET to OrdersController with :id" do
    it "should return the order with :id" do
      get :show, id: @order.id
      assigns(:order).should_not be_nil
      assigns(:order).should eq(@order)
    end
  end

  describe "POST to OrdersController" do
    it "should create a new Order" do
      post :create, order: { order_date: Date.today, comment: "This is a comment", karnevalist_id: @user.karnevalist.id }
      Order.where(comment: "This is a comment").should exist
    end
  end
end
