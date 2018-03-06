require 'rails_helper'

describe HomeController do
  include ActionController::RecordIdentifier
  include SocialStream::TestHelpers

  render_views

  describe "create" do
    context "with logged user" do
      before do
        @user = FactoryBot.create(:user)
        sign_in @user
      end

      context "to represent herself" do
        it "should redirect_to root" do
          get :index, :s => @user.slug

          expect(assigns(:current_subject)).to eq(@user)
          expect(response).to be_success
        end
      end

      context "to represent own group" do
        before do
          @group = FactoryBot.create(:member, :contact => FactoryBot.create(:group_contact, :receiver => @user.actor)).sender_subject
        end

        it "should redirect_to root" do
          get :index, :s => @group.slug

          expect(assigns(:current_subject)).to eq(@group)
          expect(response).to be_success
        end
      end

      context "representing own group" do
        before do
          @group = FactoryBot.create(:member, :contact => FactoryBot.create(:group_contact, :receiver => @user.actor)).sender_subject
          represent @group
        end

        context "to represent herself" do
          it "should redirect_to root" do
            get :index, :s => @user.slug

            expect(assigns(:current_subject)).to eq(@user)
            expect(response).to be_success
          end
        end
      end

      context "to represent other group" do
        before do
          @group = FactoryBot.create(:group)
        end

        it "should deny access" do
          begin
            get :index, :s => @group.slug

            is_expected.to be false
          rescue ActionView::Template::Error => e
            expect(e.message).to eq("Not authorized!")
          rescue CanCan::AccessDenied
            is_expected.to be_truthy
          end
        end
      end
    end
  end
end

