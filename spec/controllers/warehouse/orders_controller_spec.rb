require 'spec_helper'

describe Warehouse::OrdersController do

  before :each do
    @user = FactoryGirl.create(:user)
    sign_in @user
    @sektion = FactoryGirl.build(:sektion)
    @order = FactoryGirl.create(:order, sektion: @sektion, karnevalist: @user.karnevalist)
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
      assigns(:orders).should_not be_nil
      assigns(:orders).should eq([@order])
      response.should be_success
    end
  end

end
