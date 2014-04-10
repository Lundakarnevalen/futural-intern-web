require 'spec_helper'

describe Post do

  let(:karnevalist) { FactoryGirl.create(:karnevalist) }
  let(:sektion) { FactoryGirl.create(:sektion) }
  before { @post = Post.new(content: "HEJEJEJE", title: "Title", sektion: sektion, karnevalist: karnevalist) }

  subject { @post }

  it { should respond_to(:content) }
  it { should respond_to(:karnevalist_id) }
  it { should respond_to(:sektion_id) }
  it { should respond_to(:karnevalist) }
  its(:karnevalist) { should eq karnevalist }
  it { should respond_to(:sektion) }
  its(:sektion) { should eq sektion }

  it { should be_valid }

  describe "when karnevalist_id is not present" do
    before { @post.karnevalist_id = nil }
    it { should_not be_valid }
  end

  describe "when sektion_id is not present" do
    before { @post.sektion_id = nil }
    it { should_not be_valid }
  end

  describe "with blank content" do
    before { @post.content = " "}
    it { should_not be_valid }
  end

  describe "from sektion but not another" do
    let(:other_karnevalist) { FactoryGirl.create(:karnevalist) }
    let(:other_sektion)     { FactoryGirl.create(:sektion) }

    let(:sektion_post)        { FactoryGirl.create(:post, sektion: sektion, karnevalist: karnevalist) }
    let(:not_my_sektion_post) { FactoryGirl.create(:post, sektion: other_sektion, karnevalist: other_karnevalist) }

    subject { karnevalist.sektion.posts }

    it { should include(sektion_post) }
    it { should_not include(not_my_sektion_post) }
  end

  describe '.create' do
    it 'can actually create a sektion' do
      FactoryGirl.create(:sektion).should_not raise_error
    end
  end
end
