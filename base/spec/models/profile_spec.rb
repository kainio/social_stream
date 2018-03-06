require 'rails_helper'

describe Profile do
  context "belonging to a user" do
    before(:each) do
      @profile = FactoryBot.create(:user).profile
    end

    context "accessed by her" do
      before(:each) do
        @ability = Ability.new(@profile.subject)
      end

      it "should allow read" do
        expect(@ability).to be_able_to(:read, @profile)
      end

      it "should allow update" do
        expect(@ability).to be_able_to(:update, @profile)
      end
    end

    context "accessed by other" do
      before(:each) do
        u = FactoryBot.create(:user)
        @ability = Ability.new(u)
      end

      it "should allow read" do
        expect(@ability).to be_able_to(:read, @profile)
      end

      it "should deny update" do
        expect(@ability).to_not be_able_to(:update, @profile)
      end
    end

  end
end
