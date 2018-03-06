require 'rails_helper'

describe Site do
  it "should access configuration" do
    Site.current.config[:test] = "test"

    expect(Site.current.config[:test]).to eq("test")
  end
end
