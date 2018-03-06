require 'rails_helper'

describe UsersController do
  render_views

  describe "when Anonymous" do
    it "should render show" do
      get :show, :id => FactoryBot.create(:friend, :receiver => FactoryBot.create(:group).actor).sender_subject.to_param

      expect(response).to be_success
    end

    context "with fans" do
      before do
        @user = FactoryBot.create(:fan_activity).receiver_subject
      end

      it "should render show" do
        get :show, :id => @user.to_param

        expect(response).to be_success
      end
    end

    it "should render show with public activity" do
      activity = FactoryBot.create(:public_activity)

      get :show, :id => activity.receiver.to_param

      expect(response).to be_success
      expect(response.body).to match(/activity_#{ activity.id }/)
    end

    it "should not render edit" do
      begin
        get :edit, :id => FactoryBot.create(:user).to_param

        expect(response).to redirect_to(:new_user_session)
      end
    end
  end

  describe "when authenticated" do
    before do
      @user = FactoryBot.create(:friend, :receiver => FactoryBot.create(:group).actor).sender_subject

      sign_in @user
    end

    it "should render self page" do
      get :show, :id => @user.to_param

      expect(response).to be_success
    end

    it "should render other's page" do
      get :show, :id => FactoryBot.create(:user).to_param

      expect(response).to be_success
    end

    it "should render other's page with activity" do
      tie = FactoryBot.create(:friend, :receiver => @user.actor)
      friend = tie.sender
      FactoryBot.create(:post, :author_id  => @user.actor_id,
                     :owner_id   => friend.id,
                     :user_author_id => @user.actor_id,
                     :relation_ids => Array(tie.relation_id))

      get :show, :id => friend.to_param

      expect(response).to be_success
    end

    it "should not render other's edit" do
      begin
        get :edit, :id => FactoryBot.create(:user).to_param

        expect(response).to be false
      rescue CanCan::AccessDenied 
        expect(response).to be_truthy
      end
    end
  end
end

