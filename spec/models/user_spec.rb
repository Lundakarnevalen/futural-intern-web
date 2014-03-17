require 'spec_helper'

describe User do
  describe "authentication token" do
    it "should generate a token on save if token == nil" do
      u = FactoryGirl.build(:user)
      #sanity check
      u.authentication_token.should be_nil
      u.save
      u.authentication_token.should_not be_nil
    end

    it "should not generate a token if one is present" do
      token = "abcd123456"
      u = FactoryGirl.build(:user, authentication_token: token)
      u.save
      u.authentication_token.should eq(token)
    end

  end

  describe "is" do
    it "returns true if the user has the role" do
      u = FactoryGirl.create(:user_with_role)
      u.is?("testrole").should be_true
    end

    it "returns false if the user does not have the role" do
      u = FactoryGirl.create(:user)
      u.is?("testrole").should be_false
    end
  end

  describe "karnevalist" do
    it "should return true if the user has a karnevalist and a sektion" do
      u = FactoryGirl.create(:user)
      u.karnevalist?.should be_true 
    end

    it "should return false if the user does not have a karnevalist" do
      u = FactoryGirl.create(:user)
      u.karnevalist = nil
      u.karnevalist?.should be_false
    end

    it "should return false if the user has not been assigned a sektion" do
      u = FactoryGirl.create(:user)
      u.karnevalist.tilldelad_sektion = nil
      u.karnevalist?.should be_false
    end
  end

  describe "sektion" do
    it "should return the sektion if karnevalist is present present" do
      u = FactoryGirl.create(:user)
      u.sektioner.should_not be_blank
    end
    it "should return nil if the user does not have a karnevalist" do
      u = FactoryGirl.create(:user)
      u.karnevalist = nil
      u.sektioner.should be_nil
    end
  end
end
