describe Reservation do
  describe "validation" do
    it "should be valid if start_time > DateTime.now" do
      FactoryGirl.build(:reservation, start_time: DateTime.now + 1).should be_valid
    end
    it "should validate the presence of karnevalist" do
      FactoryGirl.build(:reservation, karnevalist: nil).should_not be_valid
    end
  end

  describe "Format date" do
    it "should format the date to a string" do
      d = DateTime.new(2014, 2, 3, 4, 0, 0, '+1')
      Reservation.format_date(d).should eq("2014-02-03 04:00:00")
    end
  end
end
