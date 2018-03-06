require 'rails_helper'

describe Group do
  it "should save description" do
    user = FactoryBot.create(:user)

    g = Group.create :name => "Test",
                     :description => "Testing description",
                     :author_id => user.actor.id,
                     :user_author_id => user.actor.id

    expect(g.reload.description).to be_present
  end

  it "should have activity_object" do
    expect(FactoryBot.create(:group).activity_object).to be_present
  end

  it "should save tag list" do
    g = FactoryBot.create(:group)

    g.tag_list = "bla, ble"
    g.save!

    expect(g.reload.tag_list).to be_present
  end
end

