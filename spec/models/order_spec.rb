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
      o = FactoryGirl.create(:order, order_date: DateTime.tomorrow.to_time)
      o.order_date.should_not eq(Date.today.to_time)
    end
  end

  describe "order_number" do
    it "should set the order_number to Order.count + 1 for orders with warehouse_code on save" do
      o = FactoryGirl.create(:order)
      o.order_number.should eq(1)
    end

    it "should only change for orders with same warehouse_code" do
      o = FactoryGirl.create(:order, warehouse_code: 1)
      o2 = FactoryGirl.create(:order, warehouse_code: 0)
      o2.order_number.should_not eq(2)
      o2.order_number.should eq(1)
    end
  end

  describe "start time" do
    it "should return the delivery date" do
      o = FactoryGirl.build(:order, order_date: DateTime.now, delivery_date: Date.tomorrow.to_time)
      o.start_time.should eq(Date.tomorrow.to_time)
    end
  end
end