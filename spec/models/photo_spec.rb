# -*- encoding : utf-8 -*-
describe Photo do
  describe "validation" do
    it "should validates the presence of an image" do
      FactoryGirl.build(:photo, image: nil).should_not be_valid
      FactoryGirl.build(:photo).should be_valid
    end

    it "should validates the presence of a karnevalist" do
      FactoryGirl.build(:photo, karnevalist: nil).should_not be_valid
      FactoryGirl.build(:photo).should be_valid
    end
  end

  describe "json output" do
    it "should include the url to the image" do
    end

    it "should have the first name and last name" do
    end

    it "should have official true if the karnevalist is a official photographer" do

    end
  end

end
