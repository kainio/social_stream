require 'rails_helper'

describe PostsController do
  include SocialStream::TestHelpers
  include SocialStream::TestHelpers::Controllers

  render_views

  describe "authorizing" do
    before :each do
      @user = FactoryBot.create(:user)
      sign_in @user
    end

    describe "posts to user" do
      describe "with first relation" do
        before(:each) do
          contact = @user.contact_to!(@user)
          relation = @user.relation_customs.sort.first
          model_assigned_to @user.contact_to!(@user), relation
          @current_model = FactoryBot.create(:post, :author_id => @user.actor_id,
                                   :owner_id  => @user.actor_id,
                                   :user_author_id => @user.actor_id,
                                   :relation_ids => Array(relation.id))
        end

        it_should_behave_like "Allow Creating"
        it_should_behave_like "Allow Reading"
        it_should_behave_like "Allow Destroying"

        it "should destroy with js" do
          count = model_count
          delete :destroy, :id => @current_model.to_param, :format => :js

          resource = assigns(model_sym)

          expect(model_count).to eq(count - 1)
        end
      end

      describe "with last relation" do
        before do
          contact = @user.contact_to!(@user)
          relation = @user.relation_customs.sort.last
          model_assigned_to @user.contact_to!(@user), relation
          @current_model = FactoryBot.create(:post, :author_id => @user.actor_id,
                                   :owner_id  => @user.actor_id,
                                   :user_author_id => @user.actor_id,
                                   :relation_ids => Array(relation.id))
        end

        it_should_behave_like "Allow Creating"
        it_should_behave_like "Allow Reading"
        it_should_behave_like "Allow Destroying"
      end

      describe "with public relation" do
        before do
          contact = @user.contact_to!(@user)
          relation = Relation::Public.instance
          model_assigned_to @user.contact_to!(@user), relation
          @current_model = FactoryBot.create(:post, :author_id => @user.actor_id,
                                   :owner_id  => @user.actor_id,
                                   :user_author_id => @user.actor_id)
        end

        it_should_behave_like "Allow Creating"
        it_should_behave_like "Allow Reading"
        it_should_behave_like "Allow Destroying"
      end
    end

    describe "post to friend" do
      before do
        friend = FactoryBot.create(:friend, :contact => FactoryBot.create(:contact, :receiver => @user.actor)).sender

        model_assigned_to @user.contact_to!(friend), friend.relation_custom('friend')
        @current_model = FactoryBot.create(:post, :author_id => @user.actor_id,
                                 :owner_id  => friend.id,
                                 :user_author_id => @user.actor_id)
      end

      it_should_behave_like "Allow Creating"
      it_should_behave_like "Allow Reading"
    end

    describe "post to acquaintance" do
      before do
        ac = FactoryBot.create(:acquaintance, :contact => FactoryBot.create(:contact, :receiver => @user.actor)).sender

        model_assigned_to @user.contact_to!(ac), ac.relation_custom('acquaintance')
      end

      it_should_behave_like "Deny Creating"
    end

    describe "post from other user" do
      before do
        @current_model = FactoryBot.create(:post)
      end


      it_should_behave_like "Deny Reading"
    end

    describe "posts represented group" do
      before do
        @group = FactoryBot.create(:member, :contact => FactoryBot.create(:group_contact, :receiver => @user.actor)).sender_subject
      end

      describe "with member relation" do
        before do
          contact = @user.contact_to!(@group)
          relation = @group.relation_custom('member')

          model_assigned_to contact, relation
          @current_model = FactoryBot.create(:post, :author_id => contact.sender.id,
                                   :owner_id  => contact.receiver.id,
                                   :user_author_id => contact.sender.id,
                                   :relation_ids => Array(relation.id))
        end

        it_should_behave_like "Allow Creating"
        it_should_behave_like "Allow Reading"
        it_should_behave_like "Allow Destroying"
      end

      context "representing the group" do
        before do
          represent(@group)
        end

        describe "with first relation" do
          before do
            contact = @group.contact_to!(@group)
            relation = @group.relation_customs.sort.first
            model_assigned_to contact, relation
            @current_model = FactoryBot.create(:post, :author_id => contact.sender.id,
                                     :owner_id  => contact.receiver.id,
                                     :user_author_id => contact.sender.id,
                                     :relation_ids => Array(relation.id))
          end

          it_should_behave_like "Allow Creating"
          it_should_behave_like "Allow Reading"
          it_should_behave_like "Allow Destroying"
        end

        describe "with last relation" do
          before do
            contact = @group.contact_to!(@group)
            relation = @group.relation_customs.sort.last
            model_assigned_to contact, relation
            @current_model = FactoryBot.create(:post, :author_id => contact.sender.id,
                                     :owner_id  => contact.receiver.id,
                                     :user_author_id => contact.sender.id,
                                     :relation_ids => Array(relation.id))
          end

          it_should_behave_like "Allow Creating"
          it_should_behave_like "Allow Reading"
          it_should_behave_like "Allow Destroying"
        end

        describe "with public relation" do
          before do
            contact = @group.contact_to!(@group)
            relation = Relation::Public.instance
            model_assigned_to contact, relation
            @current_model = FactoryBot.create(:post,  :author_id => contact.sender.id,
                                     :owner_id  => contact.receiver.id,
                                     :user_author_id => contact.sender.id,
                                     :relation_ids => Array(relation.id))
          end

          it_should_behave_like "Allow Creating"
          it_should_behave_like "Allow Reading"
          it_should_behave_like "Allow Destroying"
        end
      end
    end

    context "creating post in group's wall" do
      before do
        @tie = FactoryBot.create(:member)
      end

      it "should assign activity to member" do
        sign_in @tie.receiver_subject

        post :create, :post => { :text => "Test",
                                 :owner_id  => @tie.contact.sender.id
        }

        post = assigns(:post)

        expect(post).to be_valid
        expect(post.post_activity.relations).to include(@tie.relation)
      end

      it "should assign activity to member" do
        sign_in @tie.receiver_subject

        post :create, :post => { :text => "Test",
                                 :owner_id  => @tie.contact.sender.id
        },
          :format => :js


        post = assigns(:post)

        expect(post).to be_valid
        expect(post.post_activity.relations).to include(@tie.relation)

        expect(response).to be_success
      end
    end

    context "creating public post" do
      before :each do
        @post = FactoryBot.create(:public_post)
      end

      it "should render" do
        get :show, :id => @post.to_param

        expect(response).to be_success
      end
    end

    describe "to friend on representation change" do
      before do
        @post = FactoryBot.create(:post)

        @user = @post.post_activity.sender_subject

        @group = FactoryBot.create(:member, :contact => FactoryBot.create(:g2g_contact, :receiver => @user.actor)).sender_subject

        FactoryBot.create(:friend, :contact => FactoryBot.create(:g2g_contact, :sender => @user.actor))

        sign_in @user
      end

      it "should redirect show to home" do
        get :show, :id => @post.to_param, :s => @group.slug

        expect(response).to redirect_to(:home)
      end
    end
  end
end
