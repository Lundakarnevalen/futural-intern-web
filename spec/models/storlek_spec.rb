# -*- encoding : utf-8 -*-
describe Storlek do
	describe "to string" do
		it "should return the name" do
			s = FactoryGirl.create(:storlek)
			s.to_s.should eq(s.name)
		end	
	end
end
