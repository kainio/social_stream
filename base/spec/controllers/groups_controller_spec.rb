require 'rails_helper'

describe GroupsController do
  include SocialStream::TestHelpers
  include SocialStream::TestHelpers::Controllers

  render_views

  describe "when Anonymous" do
    it "should render show" do
      get :show, :id => FactoryBot.create(:group).to_param

      expect(response).to be_success
    end

    it "should not render new" do
      get :new

      expect(response).to redirect_to(new_user_session_path)
    end

    context "faking a new group" do
      it "should deny creating" do
        post :create, :group => { :name => "Test" }

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "an existing group" do
      before(:each) do
        @current_model = FactoryBot.create(:group)
      end

      it_should_behave_like "Deny Updating"
      it_should_behave_like "Deny Destroying"
    end
  end

  describe "when authenticated" do
    before(:each) do
      @user = FactoryBot.create(:user)

      sign_in @user
    end

    it "should render contact group" do
      @group = FactoryBot.create(:member, :contact => FactoryBot.create(:group_contact, :receiver => @user.actor)).sender_subject
      get :show, :id => @group.to_param

      expect(response).to be_success
      expect(response.body).to match(/new_post/)
    end

    it "should render other group" do
      get :show, :id => FactoryBot.create(:group).to_param

      expect(response).to be_success
    end

    it "should render new" do
      get :new

      expect(response).to be_success
    end

    context "a new own group" do
      it "should allow creating" do
        count = Group.count
        post :create, :group => { :name => "Test" }

        group = assigns(:group)

        expect(group).to be_valid
        expect(Group.count).to eq(count + 1)
        expect(assigns(:current_subject)).to eq(group)
        expect(response).to redirect_to(:home)
        expect(@user.senders).to include(group.actor)
      end

      context "with owners" do
        before do
          @user_owner = FactoryBot.create(:user)
          @group_owner = FactoryBot.create(:group)
        end

        it "should allow creating" do
          count = Group.count
          post :create,
               :group => { :name => "Test group",
                           :owners => [ @user_owner.actor_id, @group_owner.actor_id ].join(',') }

          group = assigns(:group)

          expect(group).to be_valid
          expect(Group.count).to eq(count + 1)
          expect(assigns(:current_subject)).to eq(group)

          owners = group.contact_subjects(:direction => :sent)

          expect(owners).to include(@user_owner)
          expect(owners).to include(@group_owner)

          group.contact_subjects(:direction => :received)
          expect(response).to redirect_to(:home)
        end
      end
    end

    context "a new fake group" do
      before do
        user = FactoryBot.create(:user)

        model_attributes[:author_id] = user.actor_id
        model_attributes[:user_author_id] = user.actor_id
      end

      it "should create but own" do
        count = model_count
        post :create, attributes

        resource = assigns(demodulized_model_sym)

        expect(model_count).to eq(count + 1)
        expect(resource).to be_valid
        expect(resource.author).to eq(@user.actor)
        expect(resource.user_author).to eq(@user.actor)
        expect(response).to redirect_to(:home)
      end
    end

    context "a external group" do
      before do
        @current_model = FactoryBot.create(:group)
      end

      it_should_behave_like "Deny Updating"
      it_should_behave_like "Deny Destroying"
    end


    context "a existing own group" do
      before do
        @current_model = FactoryBot.create(:member, :contact => FactoryBot.create(:group_contact, :receiver => @user.actor)).sender_subject
      end

      it "should update contact group" do
        put :update, :id => @current_model.to_param,
                     "group" => { "profile_attributes" => { "organization" => "Social Stream" } }

        expect(response).to redirect_to(@current_model)
      end

      it_should_behave_like "Allow Updating"
      it_should_behave_like "Allow Destroying"
    end

    context "representing a group" do
      before(:each) do
        @group = FactoryBot.create(:member, :contact => FactoryBot.create(:group_contact, :receiver => @user.actor)).sender_subject
        represent(@group)
      end

      it "should allow creating" do
        count = Group.count
        post :create, :group => { :name => "Test new group" }

        new_group = assigns(:group)

        expect(new_group).to be_valid
        expect(Group.count).to eq(count + 1)
        expect(assigns(:current_subject)).to eq(new_group)
        expect(response).to redirect_to(:home)
        expect(@user.senders).to include(new_group.actor)
        expect(@group.senders).to include(new_group.actor)
      end
    end
  end
end

