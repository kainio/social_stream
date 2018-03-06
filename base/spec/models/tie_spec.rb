require 'rails_helper'

describe Tie do
  describe "follower_count" do
    it "should be incremented" do
      sender, receiver = 2.times.map{ FactoryBot.create(:user) }

      count = receiver.follower_count

      follower_relation = sender.
                          relation_customs.
                          joins(:permissions).
                          merge(Permission.follow).
                          first

      Tie.create! :contact_id => sender.contact_to!(receiver).id,
                  :relation_id => follower_relation.id

      expect(receiver.reload.follower_count).to eq(count + 1)
    end
    
    it "should be decremented" do
      tie = FactoryBot.create(:friend)
      contact = tie.contact
      receiver = tie.receiver
      count = receiver.follower_count

      contact.reload.relation_ids = []

      expect(receiver.reload.follower_count).to eq(count - 1)
    end
  end

  describe "friend" do
    before(:each) do
      @tie = FactoryBot.create(:friend)
    end

    it "should create pending" do
      expect(@tie.receiver.received_contacts.pending).to be_present
    end

    it "should create activity with follow verb" do
      activity = Activity.authored_by(@tie.sender).owned_by(@tie.receiver).first
      expect(activity).to be_present
      expect(activity.verb).to eq('follow')
    end

    context "reciprocal" do
      before(:each) do
        @reciprocal = FactoryBot.create(:friend, :contact => @tie.contact.inverse!)
      end

      it "should create activity with make_friend verb" do
        activity = Activity.authored_by(@reciprocal.sender).owned_by(@reciprocal.receiver).first

        expect(activity).to be_present
        expect(activity.verb).to eq('make_friend')
      end
    end

  end

  describe "with public relation" do
    before(:each) do
      @tie = FactoryBot.create(:public)
    end

    it "should create activity" do
      count = Activity.count

      FactoryBot.create(:public)

     expect(Activity.count).to eq(count + 1)
    end

    it "should be positive" do
      expect(@tie).to be_positive
    end

    it "should not be positive replied" do
      expect(@tie).to_not be_positive_replied
    end

    context "with public reply" do
      before(:each) do
        FactoryBot.create(:public, :contact => @tie.contact.inverse!)

        # It should reload tie.contact again, as its inverse is now set
        @tie.reload
      end

      it "should be positive replied" do
        expect(@tie).to be_positive_replied
      end

      it "should be bidirectional" do
        expect(@tie).to be_bidirectional
      end
    end

    context "with reject reply" do
      before(:each) do
       FactoryBot.create(:reject, :contact => @tie.contact.inverse!)

        # It should reload tie.contact again, as its inverse is now set
        @tie.reload
      end

      it "should not be positive replied" do
        expect(@tie).to_not be_positive_replied
      end

      it "should not be bidirectional" do
        expect(@tie).to_not be_bidirectional
      end
    end
  end

  describe "with reject relation" do
    before(:each) do
      @tie = FactoryBot.create(:reject)
    end

    it "should not create activity" do
      count = Activity.count

      FactoryBot.create(:reject)

      expect(Activity.count).to eq(count)
    end

    it "should not be positive" do
      expect(@tie).to_not be_positive
    end

    context "with public reply" do
      before(:each) do
        FactoryBot.create(:public, :contact => @tie.contact.inverse!)

        # It should reload tie.contact again, as its inverse is now set
        @tie.reload
      end

      it "should be positive replied" do
        expect(@tie).to be_positive_replied
      end

      it "should not be bidirectional" do
        expect(@tie).to_not be_bidirectional
      end
    end

    context "with reject reply" do
      before(:each) do
       FactoryBot.create(:reject, :contact => @tie.contact.inverse!)

        # It should reload tie.contact again, as its inverse is now set
        @tie.reload
      end

      it "should not be positive replied" do
        expect(@tie).to_not be_positive_replied
      end

      it "should not be bidirectional" do
        expect(@tie).to_not be_bidirectional
      end
    end
  end
end

