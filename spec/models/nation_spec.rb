# -*- encoding : utf-8 -*-
describe Nation do
	describe "to string" do
		it "should return the name" do
			k = FactoryGirl.create(:nation)
			k.to_s.should eq(k.name)
		end	
	end
end
