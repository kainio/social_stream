require 'rails_helper'

describe AudienceController do
  include SocialStream::TestHelpers
  include SocialStream::TestHelpers::Controllers

  render_views

  context "with activity" do
    before :all do
      @activity = FactoryBot.create(:activity)
    end

    it "should not be redered to public" do
      get :index, :activity_id => @activity.id, :format => :js

      expect(response).to redirect_to(:new_user_session)
    end

    it "should not be rendered to anyone" do
      sign_in FactoryBot.create(:user)

      begin
        get :index, :activity_id => @activity.id, :format => :js

        assert false
      rescue CanCan::AccessDenied
        assert true
      end
    end

    it "should not be rendered to author" do
      sign_in @activity.author_subject

      get :index, :activity_id => @activity.id, :format => :js

      expect(response).to be_success
    end
  end
end
