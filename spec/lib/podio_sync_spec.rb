require 'spec_helper'

describe (PS = PodioSync) do
  describe '.to_karnevalist' do
    def should_be_identical podio_obj, local_obj
      PS.to_karnevalist(podio_obj).attributes.should 
        eq(Karnevalist.new(local_obj).attributes)
    end

    it 'handles the empty object' do
      should_be_identical({}, {})
    end

    it 'handles a simple name' do
      should_be_identical({ 'title' => 'Sven Svensson' }, 
                          { :fornamn => 'Sven', :efternamn => 'Svensson' })
    end

    it 'handles a double name' do
      should_be_identical({ 'title' => 'Sven Svenberg Svensson' },
                          { :fornamn => 'Sven', :efternamn => 'Svenberg Svensson' })
    end

    it 'handles a correct personnummer' do
      should_be_identical({ 'personnummer-2' => '1010101010' },
                          { :personnummer => '1010101010' })
    end

    it 'handles a strangely formatted personnummer' do
      should_be_identical({ 'personnummer-2' => '10101010-1010' },
                          { :personnummer => '1010101010' })
    end

    it 'handles a sample sektion' do
    end
  end
end
