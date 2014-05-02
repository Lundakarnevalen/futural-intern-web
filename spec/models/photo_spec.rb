# -*- encoding : utf-8 -*-
describe Photo do
  describe "validation" do
    it "should validates the presence of an image" do
      FactoryGirl.build(:photo, image: nil).should_not be_valid
      FactoryGirl.build(:photo).should be_valid
    end

    it "should validates the presence of a karnevalist" do
      FactoryGirl.build(:photo, karnevalist: nil).should_not be_valid
      FactoryGirl.build(:photo).should be_valid
    end
    it "should not allow captions longer than 140 chars" do
      FactoryGirl.build(:photo, caption: "a"*141).should_not be_valid
      FactoryGirl.build(:photo, caption: "b"*140).should be_valid
    end
    it "should allow blank captions" do
      FactoryGirl.build(:photo, caption: "").should be_valid
    end
  end

  describe "json output" do
    before { @p = FactoryGirl.build(:photo) }
    it "should include the url to the image" do
      @p.to_json.should have_json_path("url")
      @p.to_json.should have_json_type(String).at_path("url")
    end

    it "should include the url to the image" do
      @p.to_json.should have_json_path("thumb")
      @p.to_json.should have_json_type(String).at_path("thumb")
    end

    it "should have the name" do
      @p.to_json.should have_json_path("name")
      @p.to_json.should have_json_type(String).at_path("name")
    end

    it "should have official" do
      @p = FactoryGirl.build(:photo)
      @p.to_json.should have_json_path("official")
    end

  end

end
