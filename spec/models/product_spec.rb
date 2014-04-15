# -*- encoding : utf-8 -*-
describe Product do
  describe "validation" do
    it "should have a product_category, name, unit, supplier, purchase_price and sale_price" do
      FactoryGirl.build(:product, product_category_id: 12, name: "abc", unit: "enhet", purchase_price: "1,57", sale_price: "2.53").should be_valid
    end

    it "should not be valid if product_category is missing" do
      FactoryGirl.build(:product, product_category_id: nil, name: "abc", unit: "enhet", purchase_price: "1,57", sale_price: "2.53").should_not be_valid
    end
    
    it "should not be valid if name is missing" do
      FactoryGirl.build(:product, product_category_id: 12, name: nil, unit: "enhet", purchase_price: "1,57", sale_price: "2.53").should_not be_valid
    end
    
    it "should not be valid if unit is missing" do
      FactoryGirl.build(:product, product_category_id: 12, name: "abc", unit: nil, purchase_price: "1,57", sale_price: "2.53").should_not be_valid
    end
    
    it "should not be valid if purchase_price is missing" do
      FactoryGirl.build(:product, product_category_id: nil, name: "abc", unit: "enhet", purchase_price: nil, sale_price: "2.53").should_not be_valid
    end
    
    it "should not be valid if purchase_price is less than zero" do
      FactoryGirl.build(:product, product_category_id: nil, name: "abc", unit: "enhet", purchase_price: "-5.73", sale_price: "2.53").should_not be_valid
    end
    
    it "should not be valid if sale_price is missing" do
      FactoryGirl.build(:product, product_category_id: nil, name: "abc", unit: "enhet", purchase_price: "1,57", sale_price: nil).should_not be_valid
    end
    
    it "should not be valid if sale price is less than zero" do
      FactoryGirl.build(:product, product_category_id: nil, name: "abc", unit: "enhet", purchase_price: "1,57", sale_price: "-2.53").should_not be_valid
    end
  end
end
