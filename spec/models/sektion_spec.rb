describe Sektion do
  describe '#members' do
    it 'handles the empty case' do
      s = FactoryGirl.create :sektion
      s.members.should be_empty
    end

    it 'return all the members of the sektion' do
      s = FactoryGirl.create :sektion
      k1 = FactoryGirl.create :karnevalist, :sektion => s,
        :sektion2 => nil
      k2 = FactoryGirl.create :karnevalist, :sektion => nil,
        :sektion2 => s
      s.members.should =~ [k1, k2]
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
