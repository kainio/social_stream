require 'rails_helper'

describe Contact do
  context "inverse" do
    before :each do
      @sent = FactoryBot.create(:contact)
      @received = @sent.inverse!
    end

    it "should be set" do
      expect(@sent.reload.inverse).to eq(@received)
    end
  end

  context "with message" do
    before do
      @sent = FactoryBot.create(:contact, :message => 'Hello')
      @received = @sent.inverse!
    end

    it "should send to the receiver" do
      expect(@sent.message).to eq('Hello')
      expect(@sent.sender_subject).to eq(@received.receiver_subject)
    end
  end

  context "spurious" do
    before do
      @contact = FactoryBot.create(:contact)
      @contact.inverse!
    end

    it "should not appear as pending" do
      expect(@contact.sender.pending_contacts).to_not include(@contact)
    end
  end

  context "reject" do
    before do
      @contact = FactoryBot.create(:reject).contact
      @contact.inverse!
    end

    it "should not appear as pending" do
      expect(@contact.receiver.pending_contacts).to_not include(@contact.inverse!)
    end
  end

  context "a pair" do
    before do
      @friend = FactoryBot.create(:friend)
      @sender = @friend.sender
      @acquaintance = FactoryBot.create(:acquaintance,
                              :contact => FactoryBot.create(:contact,
                                                  :sender => @sender))
    end

    it "should scope friend" do
      expect(Contact.sent_by(@sender).count).to eq(2)
      expect(Contact.sent_by(@sender).related_by_param(nil).count).to eq(2)
      expect(Contact.sent_by(@sender).related_by_param(@friend.relation_id).count).to eq(1)
    end
  end
end
