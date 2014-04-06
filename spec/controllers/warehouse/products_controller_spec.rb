require 'spec_helper'

describe Warehouse::ProductsController do

  before :each do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  describe "GET to ProductsController" do
    it "Should show all products" do
    end
  end

  describe "GET to ProductsController with :id" do
    it "should return the product with :id" do
    end
  end

  describe "POST to ProductsController" do
    it("should create a new product") do
    end
  end
end
