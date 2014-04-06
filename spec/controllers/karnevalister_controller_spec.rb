require 'spec_helper'

describe KarnevalisterController do
  before :each do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  describe "GET to KarnvealistController" do
    before :each do
      #sanity check
      @user.roles = []
    end

    it "should assign all karnivalister for an admin" do
      @user.roles << FactoryGirl.create(:role, name: "admin")
      get :index
      assigns(:karnevalister).should_not be_nil
      assigns(:karnevalister).should eq([@user.karnevalist])
      response.should be_success
    end

    it "should only assign those of the same sektion if user is sekadmin" do
      @wrong_sektion_karnevalist = FactoryGirl.create(:karnevalist, tilldelad_sektion: 2)
      @user.roles << FactoryGirl.create(:role, name: "sektionsadmin")
      get :index
      assigns(:karnevalister).should_not be_nil
      assigns(:karnevalister).should eq([@user.karnevalist])
      assigns(:karnevalister).should_not eq([@wrong_sektion_karnevalist])
      response.should be_success
    end
  end
end
