require 'rails_helper'

describe Relation do
  context "authorization" do
    before(:all) do
      @tie = FactoryBot.create(:friend)
      @relation = @tie.relation
    end

    describe ", receiver" do
      before(:each) do
        @s = @tie.receiver
      end

      it "creates activity" do
        expect(Relation.allow(@s, 'create', 'activity')).to include(@relation)
      end

      it "reads activity" do
        expect(Relation.allow(@s, 'read', 'activity')).to include(@relation)
      end
    end

    describe ", acquaintance" do
      before(:each) do
        @s = FactoryBot.create(:acquaintance, :contact => FactoryBot.create(:contact, :sender => @tie.sender)).receiver
      end

      it "creates activity" do
        expect(Relation.allow(@s, 'create', 'activity')).to_not include(@relation)
      end

      it "reads activity" do
        expect(Relation.allow(@s, 'read', 'activity')).to_not include(@relation)
      end
    end

    describe ", alien" do
      before(:each) do
        @s = FactoryBot.create(:user)
      end

      it "creates activity" do
        expect(Relation.allow(@s, 'create', 'activity')).to_not include(@relation)
      end
      
      it "reads activity" do
        expect(Relation.allow(@s, 'read', 'activity')).to_not include(@relation)
      end
    end
  end

  describe "member" do
    before(:each) do
      @tie = FactoryBot.create(:member)
      @relation = @tie.relation
    end

    describe ", member" do
      before(:each) do
        @s = FactoryBot.create(:member, :contact => FactoryBot.create(:contact, :sender => @tie.sender)).receiver
      end

      it "creates activity" do
        expect(Relation.allow(@s, 'create', 'activity')).to include(@relation)
      end

       it "reads activity" do
        expect(Relation.allow(@s, 'read', 'activity')).to include(@relation)
      end

      it "updates activity" do
        expect(Relation.allow(@s, 'update', 'activity')).to_not include(@relation)
      end
    end
  end

  describe 'with follow permission' do
    before(:each) do
      @relation = Relation.create!
      @relation.permissions << Permission.find_or_create_by(action: 'follow')
    end

    it 'should follow?' do
      expect(@relation.follow?).to be true
    end
  end

  describe 'without follow permission' do
    before(:each) do
      @relation = Relation.create!
    end

    it 'should follow?' do
      expect(@relation.follow?).to be false
    end
  end

end

