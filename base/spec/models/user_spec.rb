require 'spec_helper'

describe User do
  before do
    @user = Factory(:user)
  end

  it "should find by slug" do
    assert @user.should == User.find_by_slug(@user.slug)
  end

  context "member of a group" do
    before do
      tie = Factory(:member, :contact => Factory(:group_contact, :receiver => @user.actor))
      @group = tie.sender_subject
    end

    context "without accept the group" do
      it "should not represent" do
        @user.represented.should_not include(@group)
      end
    end

    context "accepting the group" do
      before do
        Factory(:friend, :contact => @user.contact_to!(@group))
      end

      it "should represent" do
        @user.represented.should include(@group)
      end

      context "and a second group" do
        before do
          @second_group =
            Factory(:member,
                    :contact => Factory(:group_contact,
                                        :receiver => @user.actor)
                   ).sender_subject
          Factory(:friend, :contact => @user.contact_to!(@second_group))
        end

        it "should represent both groups" do
          @user.represented.should include(@group)
          @user.represented.should include(@second_group)
        end
      end
    end
  end

  context "partner of a group" do
    before do
      tie = Factory(:partner, :contact => Factory(:group_contact, :receiver => @user.actor))
      @group = tie.receiver_subject
    end

    context "without accept the group" do
      it "should not represent" do
        @user.represented.should_not include(@group)
      end
    end

    context "accepting the group" do
      before do
        Factory(:friend, :contact => @user.contact_to!(@group))
      end

      it "should not represent" do
        @user.represented.should_not include(@group)
      end
    end
  end

  context "public of a group" do
    before do
      tie = Factory(:group_public, :contact => Factory(:group_contact, :receiver => @user.actor))
      @group = tie.receiver_subject
    end

    context "without accept the group" do
      it "should not represent" do
        @user.represented.should_not include(@group)
      end
    end

    context "accepting the group" do
      before do
        Factory(:friend, :contact => @user.contact_to!(@group))
      end

      it "should not represent" do
        @user.represented.should_not include(@group)
      end
    end
  end

  it "should have activity object" do
    Factory(:user).activity_object.should be_present
  end

  it "should update password" do
    user = Factory(:user)
    user.password = "testing321"
    user.password_confirmation = "testing321"

    assert user.save
  end
end

