describe Phone do
	describe "members" do
		it "return the members of the sektion" do
			s = FactoryGirl.create(:sektion)
			k = FactoryGirl.create(:karnevalist, tilldelad_sektion: s.id)
			s.members.should eq([k])
		end
	end
end