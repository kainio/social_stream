require 'rails_helper'

describe Site::Current do
  it "should save configuration" do
    Site::Current.instance.config[:test] = "test"

    Site::Current.instance.save!

    expect(Site::Current.instance_variable_defined?("@instance")).to be true

    Site::Current.instance_variable_set "@current", nil

    expect(Site::Current.instance.config[:test]).to eq("test")
  end

end
