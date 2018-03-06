require 'rails_helper'

describe ActivityAction do
  context "a following contact" do
    before :each do
      @tie = FactoryBot.create(:friend)
    end

    it "should create follow action" do
      action = @tie.sender.action_to(@tie.receiver)

      expect(action).to be_present
      expect(action).to be_follow
    end

    it "should remove follow action" do
      action = @tie.sender.action_to(@tie.receiver)

      expect(action).to be_present

      @tie.destroy

      expect(action.reload).to_not be_follow
    end

    describe "where posting to other owner" do
      before :each do
        @post = FactoryBot.create(:post)
      end

      it "should not be duplicated" do
        expect(@post.received_actions.count).to eq(2)
      end

      it "should initialize follower count" do
        expect(@post.reload.follower_count).to eq(2)
      end
    end

    describe "where posting to self" do
      before do
        @post = FactoryBot.create(:self_post)
      end

      it "should not be duplicated" do
        expect(@post.received_actions.count).to eq(1)
      end

      it "should initialize follower count" do
        expect(@post.reload.follower_count).to eq(1)
      end
    end

    describe "where building the post" do
      before :each do
        user = FactoryBot.create(:user)
        @post = Post.new :text => "Testing",
                         :author => user,
                         :owner  => user,
                         :user_author => user
        @post.save!
      end

      it "should not be duplicated" do
        expect(@post.received_actions.count).to eq(1)
      end
    end
  end
end
