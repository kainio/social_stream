require 'rails_helper'

describe User do
  before(:each) do
    @user = FactoryBot.create(:user)
  end

  it "should find by slug" do
    expect(@user).to eq(User.find_by_slug(@user.slug))
  end

  context "member of a group" do
    before(:each) do
      tie = FactoryBot.create(:member, :contact => FactoryBot.create(:group_contact, :receiver => @user.actor))
      @group = tie.sender_subject
    end

    context "without accept the group" do
      it "should not represent" do
        expect(@user.represented).to_not include(@group)
      end
    end

    context "accepting the group" do
      before(:each) do
        FactoryBot.create(:friend, :contact => @user.contact_to!(@group))
      end

      it "should represent" do
        expect(@user.represented).to include(@group)
      end

      context "and a second group" do
        before(:each) do
          @second_group =
            FactoryBot.create(:member,
                    :contact => FactoryBot.create(:group_contact,
                                        :receiver => @user.actor)
                   ).sender_subject
          FactoryBot.create(:friend, :contact => @user.contact_to!(@second_group))
        end

        it "should represent both groups" do
          expect(@user.represented).to include(@group)
          expect(@user.represented).to include(@second_group)
        end
      end
    end
  end

  context "partner of a group" do
    before do
      tie = FactoryBot.create(:partner, :contact => FactoryBot.create(:group_contact, :receiver => @user.actor))
      @group = tie.receiver_subject
    end

    context "without accept the group" do
      it "should not represent" do
        expect(@user.represented).to_not include(@group)
      end
    end

    context "accepting the group" do
      before :each do
        FactoryBot.create(:friend, :contact => @user.contact_to!(@group))
      end

      it "should not represent" do
        expect(@user.represented).to_not include(@group)
      end
    end
  end

  context "public of a group" do
    before :each do
      tie = FactoryBot.create(:group_public, :contact => FactoryBot.create(:group_contact, :receiver => @user.actor))
      @group = tie.receiver_subject
    end

    context "without accept the group" do
      it "should not represent" do
        expect(@user.represented).to_not include(@group)
      end
    end

    context "accepting the group" do
      before :each do
        FactoryBot.create(:friend, :contact => @user.contact_to!(@group))
      end

      it "should not represent" do
        expect(@user.represented).to_not include(@group)
      end
    end
  end

  it "should have activity object" do
    expect(FactoryBot.create(:user).activity_object).to be_present
  end

  it "should update password" do
    user = FactoryBot.create(:user)
    user.password = "testing321"
    user.password_confirmation = "testing321"

    expect(user.save).to be true
  end
end

