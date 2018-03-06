require 'rails_helper'

describe ProfilesController do
  include SocialStream::TestHelpers
  render_views

  context "for a user" do
    before do
      @user = FactoryBot.create(:user)
      sign_in @user
    end

    it "should render show" do
      get :show

      expect(response).to be_success
    end

    it "should render show.json" do
      get :show, format: :json

      expect(response).to be_success
    end

    it "should render show with user param" do
      get :show, :user_id => @user.to_param

      expect(response).to be_success
    end

    it "should update" do
      put :update, :user_id => @user.to_param, :profile => { :organization => "Social Stream" }

      expect(response).to redirect_to([@user, :profile])
    end

    it "should update via AJAX" do
      put :update, :user_id => @user.to_param, :profile => { :organization => "Social Stream" }, :format => :js

      expect(response).to be_success
    end


    it "should not update other's" do
      begin
        put :update, :user_id => FactoryBot.create(:user).to_param, :profile => { :organization => "Social Stream" }

        is_expected.to be false
      rescue CanCan::AccessDenied
        is_expected.to be_truthy
      end
    end

  end

  context "for a group" do
    before do
      membership = FactoryBot.create(:member)
      @group = membership.sender_subject
      @user  = membership.receiver_subject

      sign_in @user
      represent @group
    end

    it "should render show" do
      get :show, :group_id => @group.to_param

      expect(response).to be_success
    end

    it "should update" do
      put :update, :group_id => @group.to_param, :profile => { :organization => "Social Stream" }

      expect(response).to redirect_to([@group, :profile])
    end

    it "should not update other's" do
      begin
        put :update, :group_id => FactoryBot.create(:group).to_param, :profile => { :organization => "Social Stream" }

        is_expected.to be false
      rescue CanCan::AccessDenied
        is_expected.to be_truthy
      end
    end
  end
end

