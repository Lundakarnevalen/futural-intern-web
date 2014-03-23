require 'spec_helper'

describe Warehouse::OrdersController do

  before :each do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  describe "GET to OrdersController" do
    it "Should show all orders" do
    end
  end

  describe "GET to OrdersController with :id" do
    it "should return the product with :id" do
    end
  end

  describe "POST to OrdersController" do
    it "should create a new Order" do
    end
  end
end
