require 'rails_helper'

describe Like do
  shared_examples_for "creates activity" do
    it "should recognize the user who likes it" do
      Like.build(@sender, @sender, @receiver).save

      expect(@receiver.liked_by?(@sender)).to be true
    end

    it "should increment like count" do
      count = @receiver.like_count

      Like.build(@sender, @sender, @receiver).save

      expect(@receiver.like_count).to eq(count + 1)
    end

    it "should decrement like count" do
      @like = Like.build(@sender, @sender, @receiver)
      @like.save

      count = @receiver.like_count

      @like.destroy

      expect(@receiver.like_count).to eq(count - 1)
    end
  end

  describe "activity" do
    before(:each) do
      @like_activity = FactoryBot.create(:like_activity)
      @activity = @like_activity.parent
      @sender = @like_activity.sender
      @receiver = @activity
    end

    it "should recognize the user who likes it" do
      expect(@activity.liked_by?(@like_activity.sender)).to be true
    end

    it "should not recognize the user who does not like it" do
      expect(! @activity.liked_by?(FactoryBot.create(:user))).to be true
    end
  end

  describe "actor" do

    context "friend" do
      before do
        tie = FactoryBot.create(:friend)
        @sender = tie.sender
        @receiver = tie.receiver
      end

      it_should_behave_like "creates activity"
    end

    context "alien" do
      before do
        @sender, @receiver = 2.times.map{ FactoryBot.create(:user) }
      end

      it_should_behave_like "creates activity"
    end
  end

  describe "post" do
    before do
      @receiver = FactoryBot.create(:post)
      @sender = FactoryBot.create(:user)
    end

    it_should_behave_like "creates activity"
  end

  describe "comment" do
    before do
      @receiver = FactoryBot.create(:comment)
      @sender = FactoryBot.create(:user)
    end

    it_should_behave_like "creates activity"
  end
end


