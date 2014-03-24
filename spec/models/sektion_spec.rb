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
end
