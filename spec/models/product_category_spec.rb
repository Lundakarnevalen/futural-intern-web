# -*- encoding : utf-8 -*-
describe Product do
  describe "validation" do
    it "should have a name" do
      FactoryGirl.build(:product_category, name: "abc").should be_valid
    end

    it "should not be valid if name is missing" do
      FactoryGirl.build(:product_category, name: nil).should_not be_valid
    end
  end
end
