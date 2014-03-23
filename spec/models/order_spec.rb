describe Order do

  describe "validation" do
    it "should validate the presence of a karnevalist" do
      FactoryGirl.build(:order, karnevalist: nil).should_not be_valid
      FactoryGirl.build(:order).should be_valid
    end
  end

  describe "order_date" do
    it "should set the order_date to Date.today if there is no order_date present" do
      o = FactoryGirl.create(:order, order_date: nil)
      o.order_date.should_not be_nil
    end

    it "should not set the order if it is already present" do
      o = FactoryGirl.create(:order, order_date: Date.tomorrow)
      o.order_date.should_not eq(Date.today)
    end
  end
end
