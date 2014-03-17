describe Korkort do
	describe "to string" do
		it "should return the name" do
			k = FactoryGirl.create(:korkort)
			k.to_s.should eq(k.name)
		end	
	end
end