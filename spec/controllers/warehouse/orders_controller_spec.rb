require 'spec_helper'

describe Warehouse::OrdersController do

  before :each do
    @user = FactoryGirl.create(:user_with_role)
    sign_in @user
    @order = FactoryGirl.create(:order)
  end

  describe "GET to OrdersController" do
    it "Should show all orders" do

    end
  end

  describe "GET to OrdersController with :id" do
  end

  describe "POST to OrdersController" do
  end

  describe "GET calendar to OrdersController" do
    it "should return all events where there is a delivery date" do
      @warehouse_code = 0
      get :calendar
      response.should be_success
      assigns(:orders).should eq([@order])
    end
  end

end
