describe Phone do
  describe "members" do
    it "return the members of the sektion" do
      s = FactoryGirl.create(:sektion)
      k = FactoryGirl.create(:karnevalist, tilldelad_sektion: s.id)
      s.members.should eq([k])
    end
  end

  describe "post associations" do
    let(:karnevalist) { FactoryGirl.create(:karnevalist) }
    let(:sektion)     { FactoryGirl.create(:sektion) }

    before { karnevalist.save }
    let!(:older_post) do
      FactoryGirl.create(:post, karnevalist: karnevalist, sektion: sektion, created_at: 1.day.ago)
    end
    let!(:newer_post) do
      FactoryGirl.create(:post, karnevalist: karnevalist, sektion: sektion, created_at: 1.hour.ago)
    end

    it "should have the right posts in the right order" do
      expect(sektion.posts.to_a).to eq [newer_post, older_post]
    end
  end
end
