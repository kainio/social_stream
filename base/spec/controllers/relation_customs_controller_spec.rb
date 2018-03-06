require 'rails_helper'

describe Relation::CustomsController do
  render_views

  describe "when Anonymous" do
    context "faking a new relation" do
      it "should not create" do
        post :create, :custom => FactoryBot.attributes_for(:relation_custom)

       expect(response).to redirect_to(:new_user_session)
      end
    end

    context "an existing relation" do
      before do
        @relation = FactoryBot.create(:relation_custom)
      end

      it "should not update" do
        put :update, :id => @relation.to_param, :custom => { :name => 'Testing' }

        expect(assigns(:custom)).to be_blank
        expect(response).to redirect_to(:new_user_session)
      end

      it "should not destroy" do
        count = Relation.count
        begin
          delete :destroy, :id => @relation.to_param
        rescue CanCan::AccessDenied
        end

        relation = assigns(:custom)

        expect(Relation.count).to eq(count)
      end

    end
  end


  describe "when authenticated" do
    before do
      @user = FactoryBot.create(:user)

      sign_in @user
    end

    it "should render index" do
      get :index

      expect(response).to be_success
    end

    context "a new own relation" do
      it "should be created" do
        count = Relation::Custom.count

        post :create, :custom => { :name => "Test create", :actor_id => @user.actor_id }, :format => 'js'

        relation = assigns(:custom)

        expect(Relation::Custom.count).to eq(count + 1)
        expect(relation).to be_valid
        expect(response).to be_success
      end
    end

    context "a new fake relation" do
      it "should not be created" do
        actor = FactoryBot.create(:user).actor
        count = Relation.count
	begin
          post :create, :custom => { :name => 'Test', :actor_id => actor.id }

          expect(assigns(:custom)).to_not be_new_record
          expect(assigns(:custom).actor_id).to eq(@user.actor_id)
        rescue CanCan::AccessDenied
          expect(assigns(:custom)).to be_new_record

          expect(Relation.count).to eq(count)
        end
      end
    end

    context "a existing own relation" do
      before do
        @relation = FactoryBot.create(:relation_custom, :actor => @user.actor)
      end

      it "should allow updating" do
        attrs = { :name => "Updating own" }

        put :update, :id => @relation.to_param, :relation_custom => attrs, :format => 'js'

        relation = assigns(:custom)

#          relation.should_receive(:update_attributes).with(attrs)
        expect(relation).to be_valid
        expect(response).to be_success
      end

      it "should allow destroying" do
        count = Relation::Custom.count

        delete :destroy, :id => @relation.to_param

        expect(Relation::Custom.count).to eq(count - 1)
      end
    end

    context "a external relation" do
      before do
        @relation = FactoryBot.create(:relation_custom)
      end

      it "should not allow updating" do
        begin
          put :update, :id => @relation.to_param, :relation_custom => { :name => "Updating external" }, :format => 'js'

          is_expected.to be false
        rescue CanCan::AccessDenied
          expect(assigns(:relation)).to be_nil
        end
      end

      it "should not allow destroying" do
        begin
          delete :destroy, :id => @relation.to_param

          is_expected.to be false
        rescue CanCan::AccessDenied
          expect(assigns(:relation)).to be_nil
        end
      end
    end
  end
end

