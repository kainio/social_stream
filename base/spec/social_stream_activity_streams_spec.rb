require 'rails_helper'

describe SocialStream::ActivityStreams do
  it "should find by type" do
    expect(SocialStream::ActivityStreams.model(:person)).to eq(User)
  end

  it "should return Post as default model" do
    expect(SocialStream::ActivityStreams.model!(:_test)).to eq(Post)
  end

  it "should find by model" do
    expect(SocialStream::ActivityStreams.type(User).should).to eq(:person)
  end
end

