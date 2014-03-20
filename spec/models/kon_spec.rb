describe Kon do
	describe "to string" do
		it "should return the name" do
			k = FactoryGirl.create(:kon)
			k.to_s.should eq(k.name)
		end	
	end
end