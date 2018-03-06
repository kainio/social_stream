require 'rails_helper'

describe ContactsController do
  include SocialStream::TestHelpers
  include SocialStream::TestHelpers::Controllers

  render_views

  before(:all) do
    @tie = FactoryBot.create(:friend)
    @user = @tie.sender_subject
  end

  context "anonymous" do
    it "should render index" do
      get 'index', user_id: @user.to_param

      expect(response).to be_success
    end
  end

  context "authenticated" do
    before(:each) do
      sign_in @user
    end

    it "should render index" do
      get 'index'

      expect(response).to be_success
    end
  end

  it "should render pending" do
    pending
    
    get 'pending'

    expect(response).to be_success
  end

  it "should render update" do
    sign_in @user

    put :update, :id => @tie.contact_id,
                 :contact => { "relation_ids" => [ @user.relations.last.id ] }

    expect(response).to redirect_to(@tie.receiver_subject)
    expect(@user.reload.
      sent_ties.
      merge(Contact.received_by(@tie.receiver)).
      first.relation).to eq(@user.relations.last)
  end

  it "should create contact" do
    sign_in @user

    group = FactoryBot.create(:group)
    contact = @user.contact_to!(group)
    

    put :update, :id => contact.id,
                 :contact => { :relation_ids => [ @user.relations.last.id ],
                               :message => "Testing" }

    expect(response).to redirect_to(contact.receiver_subject)
    expect(contact.reload.
      ties.
      first.relation).
      to eq(@user.relations.last)
  end

  it "should create contact with several relations" do
    sign_in @user

    group = FactoryBot.create(:group)
    contact = @user.contact_to!(group)
    # Initialize inverse contact
    contact.inverse!
    relations = [ @user.relation_custom('friend'), @user.relation_custom('colleague') ]
    

    put :update, :id => contact.id,
                 :contact => { :relation_ids => relations.map(&:id),
                               :message => "Testing" }

    expect(response).to redirect_to(contact.receiver_subject)

    expect(contact.reload.
      ties.
      map(&:relation).
      map(&:id).sort).
      to eq(relations.map(&:id).sort)
  end

  context "with reflexive contact" do
    before do
      @contact = @user.ego_contact
    end

    it "should render update" do
      sign_in @user

      put :update, :id => @contact,
                   :contact => { "relation_ids" => [ @user.relations.last.id ] }

      expect(response).to redirect_to(home_path)
    end
  end

  context "representing a group" do
    before(:all) do
      @group = FactoryBot.create(:member, :contact => FactoryBot.create(:group_contact, :receiver => @user.actor)).sender_subject
    end

    before do
      sign_in(@user)
      represent(@group)
    end

    it "should add other user as member" do
      other_user = FactoryBot.create(:user)
      contact = @group.contact_to!(other_user)

      put :update, :id => contact.id, :contact => { :relation_ids => @group.relation_customs.map(&:id) }

      expect(response).to redirect_to(other_user)

      expect(@group.receivers).to include(other_user.actor)
    end
  end
end
