require 'rails_helper'

describe PermissionsController do
  include SocialStream::TestHelpers::Controllers

  render_views

  describe "when authenticated" do
    before(:each) do
      @user = FactoryBot.create(:user)

      sign_in @user
    end

    context "with an existing relation" do
      before(:each) do
        @relation = FactoryBot.create(:relation_custom, :actor_id => @user.actor_id)
      end

      it "should render index" do
        get :index, :relation_id => @relation.id, :format => "html"

        expect(response).to be_success
      end
    end

    context "a external relation" do
      before do
        @relation = FactoryBot.create(:relation_custom)
      end

      it "should not render index" do
        expect {
          get :index, :relation_id => @relation.id, :format => "html"
        }.to raise_error(CanCan::AccessDenied)
      end
    end
  end
end


