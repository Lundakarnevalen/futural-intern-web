require 'spec_helper'

describe Warehouse::ReservationsController do

  before :each do
    @user = FactoryGirl.create(:user_with_role)
    sign_in @user
    @reservation = FactoryGirl.create(:reservation)
  end

  describe "GET to ReservationsController" do
    it "Should show all reservations" do
    end
    it "should return events scoped between start & end" do
    end
  end

  describe "GET to ReservationsController with :id" do
  end

  describe "POST to ReservationsController" do
  end

  describe "GET calendar to OrdersController" do
  end

end
