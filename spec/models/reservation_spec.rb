describe Reservation do
  describe "validation" do
    it "should be valid if start_time > DateTime.now" do
      FactoryGirl.build(:reservation, start_time: DateTime.now + 1).should be_valid
    end
  end

  describe "total time" do
    it "should be the difference between start_time & end_time" do
      s = DateTime.now + 1
      e = s + 1
      FactoryGirl.build(:reservation, start_time: s, end_time: e)
    end
  end
end
