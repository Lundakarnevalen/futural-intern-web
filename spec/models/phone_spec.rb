# -*- encoding : utf-8 -*-
describe Phone do
	describe "validation" do
		it "google token should be unique" do
			p = FactoryGirl.create(:phone)
			p2 = FactoryGirl.build(:phone, google_token: p.google_token).should_not be_valid
		end
	end
end
