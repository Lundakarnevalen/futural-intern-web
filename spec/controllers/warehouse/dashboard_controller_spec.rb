require 'spec_helper'

describe Warehouse::DashboardController do

  before :each do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  describe "GET to DashboardController" do
    it "" do
    end
  end
end
