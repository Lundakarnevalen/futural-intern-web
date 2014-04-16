require 'spec_helper'

describe Warehouse::ReservationsController do

  before :each do
    s = FactoryGirl.create(:sektion)
    r = FactoryGirl.create(:role)
    @user = FactoryGirl.create(:user, karnevalist: FactoryGirl.create(:karnevalist, tilldelad_sektion: s.id))
    @user.roles << r
    sign_in @user
  end

  describe "POST to ReservationsController" do
    it "should create a new reservation" do
      d = DateTime.now
      post :create, reservation: {start_time: d, end_time: d + 1, karnevalist_id: @user.karnevalist.id}, format: :json
      response.code.should eq("201")
    end
  end

end
