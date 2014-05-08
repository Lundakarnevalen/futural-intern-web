describe Reservation do
  describe "validation" do
    it "should be valid if start_time > DateTime.now" do
      FactoryGirl.build(:reservation, start_time: DateTime.now + 1).should be_valid
    end

    it "should not be valid if the start_time begins before now" do
      FactoryGirl.build(:reservation, start_time: DateTime.yesterday).should_not be_valid
    end

    it "should validate the presence of karnevalist" do
      FactoryGirl.build(:reservation, karnevalist: nil).should_not be_valid
    end

    it "should not be able to book if there are more than 6 reservations for that time" do
      FactoryGirl.create_list(:reservation, 6)
      FactoryGirl.build(:reservation).should_not be_valid
    end
  end

  describe "Format date" do
    it "should format the date to a string" do
      d = DateTime.new(2014, 2, 3, 4, 0, 0, '+1')
      Reservation.format_date(d).should eq("2014-02-03 04:00:00")
    end
  end
end
