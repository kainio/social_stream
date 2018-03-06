require 'rails_helper'

describe CommentsController do
  include SocialStream::TestHelpers::Controllers

  render_views

  describe "authorizing" do
    before do
      @user = FactoryBot.create(:user)
      sign_in @user
    end

    describe "comment from user" do
      before do
        activity = FactoryBot.create(:self_activity, :author => @user.actor)

        model_attributes[:author_id] = @user.actor_id
        model_attributes[:owner_id]  = @user.actor_id
        model_attributes[:user_author_id] = @user.actor_id
        model_attributes[:_activity_parent_id] = activity.id
      end

      it_should_behave_like "Allow Creating"

      it "should create with js" do
        count = model_count
        post :create, attributes.merge(:format => :js)

        resource = assigns(model_sym)

        expect(model_count).to eq(count + 1)
        expect(resource).to be_valid
        expect(response).to be_success
      end
    end

    describe "comment to friend" do
      before do
        f = FactoryBot.create(:friend, :contact => FactoryBot.create(:contact, :receiver => @user.actor)).sender
        activity = FactoryBot.create(:self_activity, :author => f)

        model_attributes[:author_id] = @user.actor_id
        model_attributes[:owner_id]  = f.id
        model_attributes[:user_author_id] = @user.actor_id
        model_attributes[:_activity_parent_id] = activity.id
      end

      it_should_behave_like "Allow Creating"
    end

    describe "post to acquaintance" do
      before do
        a = FactoryBot.create(:acquaintance, :contact => FactoryBot.create(:contact, :receiver => @user.actor)).sender
        activity = FactoryBot.create(:self_activity, :author => a)

        model_attributes[:author_id] = @user.actor_id
        model_attributes[:owner_id]  = a.id
        model_attributes[:user_author_id] = @user.actor_id
        model_attributes[:_activity_parent_id] = activity.id
      end

      it_should_behave_like "Deny Creating"
    end
  end
end
