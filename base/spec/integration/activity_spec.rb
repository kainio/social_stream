require 'rails_helper'

describe Activity do
  before(:all) do
    @activity = FactoryBot.create(:activity)
  end

  it "should be destroyed along with its author" do
    author = @activity.author
    activity_id = @activity.id

    author.destroy

    expect(Activity.find_by_id(activity_id)).to be_nil
  end
end
