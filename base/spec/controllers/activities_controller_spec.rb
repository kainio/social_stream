require 'rails_helper'

describe ActivitiesController do
  describe "show" do
    it "should redirecto to activity object" do
      id = 3
      activity = double("activity")
      post = FactoryBot.create(:post)

      expect(activity).to receive(:direct_object) { post }

      expect(Activity).to receive(:find).with(id.to_s) { activity }

      get :show, id: id
    end
  end
end

