require 'rails_helper'

describe HomeController do
  include SocialStream::TestHelpers

  render_views

  describe "when Anonymous" do
    it "should redirect to login" do
      get :index
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "when authenticated" do
    before(:each) do
      @user = FactoryBot.create(:user)
      sign_in @user
    end

    it "should render" do
      get :index

      expect(response).to be_success
      expect(response.body).to match(/new_post/)
    end

    context "with a group" do
      before(:each) do
        FactoryBot.create(:friend,
                :contact => FactoryBot.create(:g2g_contact, :sender => @user.actor))
      end

      it "should render" do
        get :index

        expect(response).to be_success
        expect(response.body).to match(/new_post/)
      end
    end

    describe "when representing" do
      before(:each) do
        @represented = represent(FactoryBot.create(:group))
      end

      it "should render represented home" do
        get :index

        expect(response).to be_success
        expect(assigns(:current_subject)).to eq(@represented)
      end
    end
  end
end

