require 'rails_helper'

describe Post do
  before(:each) do
    @post = FactoryBot.create(:post)
    @post_activity_object = @post.activity_object
    @post_activity = @post.post_activity
  end 

  describe "with like activity" do
    before(:each) do
      @like_activity = FactoryBot.create(:like_activity, :parent => @post_activity)
    end

    describe "when destroying" do
      before(:each) do
        @post.try(:destroy)
      end

      it "should also destroy its activity_object" do
        expect(ActivityObject.find_by_id(@post_activity_object.id)).to be_nil
      end

      it "should also destroy its post_activity" do
        expect(Activity.find_by_id(@post_activity.id)).to be_nil
      end

      it "should also destroy its children like activity" do
        expect(Activity.find_by_id(@like_activity.id)).to be_nil
      end
    end
  end

  describe 'with default SocialStream.custom_relations' do

    it "should allow create to friend" do
      tie = FactoryBot.create(:friend)

      post = Post.new :text => "testing",
        :author_id => tie.receiver.id,
        :owner_id => tie.sender.id,
        :user_author_id => tie.receiver.id

      ability = Ability.new(tie.receiver_subject)

      expect(ability).to be_able_to(:create, post)
    end

    it "should fill relation" do
      tie = FactoryBot.create(:friend)

      post = Post.new :text => "testing",
        :author_id => tie.receiver.id,
        :owner_id => tie.sender.id,
        :user_author_id => tie.receiver.id

      post.save!

      expect(post.post_activity.relations).to include(tie.relation)
    end

    describe "a new post" do
      before(:each) do
        @user = FactoryBot.create(:user)
        @post = Post.create!(:text => "test",
                             :author_id => @user.actor_id)
      end

      it "should be shared with user relations" do
        expect(@post.relation_ids.sort).to eq(@user.relation_ids.sort)
      end
    end
  end

  describe "authored_by" do
    it "should work" do
      post = FactoryBot.create(:post)

      expect(Post.authored_by(post.author)).to include(post)
    end
  end
end
