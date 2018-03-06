require 'rails_helper'

describe Relation::Follow do
  it "should have permissions" do
    expect(Relation::Follow.instance.permissions).to include(Permission.find_or_create_by(action: 'follow', object: nil))
  end
end

