describe Notification do
	describe "validations" do
		it "should have a title and a message" do
			FactoryGirl.build(:notification, message: "abc", title: "title").should be_valid
		end

		it "should not be valid if title or message is missing" do
			FactoryGirl.build(:notification, message: nil, title: "title").should_not be_valid
			FactoryGirl.build(:notification, message: "message", title: nil).should_not be_valid
		end
	end
	
end