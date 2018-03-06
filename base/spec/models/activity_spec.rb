require 'rails_helper'

describe Activity do

  describe "wall" do
    context "with a friend activity" do
      before do
        @activity = FactoryBot.create(:activity)
      end

      describe "sender home" do
        it "should include activity" do
          expect(Activity.timeline(:home, @activity.sender)).to include(@activity)
        end
      end

      describe "receiver home" do
        it "should include activity" do
          expect(Activity.timeline(:home, @activity.receiver)).to include(@activity)
        end
      end

      describe "alien home" do
        it "should not include activity" do
          expect(Activity.timeline(:home, FactoryBot.create(:user))).to_not include(@activity)
        end
      end

      describe "friend's profile" do
        it "should not include activity" do
          friend = FactoryBot.create(:friend, :contact => FactoryBot.create(:contact, :sender => @activity.sender)).receiver
          expect(Activity.timeline(friend, @activity.sender)).to_not include(@activity)
        end
      end

      describe "sender profile" do
        context "for sender" do
          it "should include activity" do
            expect(Activity.timeline(@activity.sender, @activity.sender)).to include(@activity)
          end
        end

        context "for receiver" do
          it "should include activity" do
            expect(Activity.timeline(@activity.sender, @activity.receiver)).to include(@activity)
          end
        end
      end

      describe "public timeline" do
        it "should not include activity" do
          expect(Activity.timeline).to_not include(@activity)
        end
      end
    end

    context "with a self friend activity" do
      before do
        @activity = FactoryBot.create(:self_activity)
      end

      describe "friend's profile" do
        it "should not include activity" do
          friend = FactoryBot.create(:friend, :contact => FactoryBot.create(:contact, :sender => @activity.sender)).receiver
          expect(Activity.timeline(friend, @activity.sender)).to_not include(@activity)
        end
      end

      describe "public timeline" do
        it "should not include activity" do
          expect(Activity.timeline).to_not include(@activity)
        end
      end
    end

    context "with a public activity" do
      before do
        @activity = FactoryBot.create(:public_activity)
      end

      describe "sender home" do
        it "should include activity" do
          expect(Activity.timeline(:home, @activity.sender)).to include(@activity)
        end
      end

      describe "receiver home" do
        it "should include activity" do
          expect(Activity.timeline(:home, @activity.receiver)).to include(@activity)
        end
      end

      describe "alien home" do
        it "should not include activity" do
          expect(Activity.timeline(:home, FactoryBot.create(:user))).to_not include(@activity)
        end
      end

      describe "sender profile" do
        context "for sender" do
          it "should include activity" do
            expect(Activity.timeline(@activity.sender, @activity.sender)).to include(@activity)
          end
        end

        context "for receiver" do
          it "should include activity" do
            expect(Activity.timeline(@activity.sender, @activity.receiver)).to include(@activity)
          end
        end

        context "for Anonymous" do
          it "should include activity" do
            expect(Activity.timeline(@activity.sender, nil)).to include(@activity)
          end
        end
      end

      describe "receiver profile" do
        context "for sender" do
          it "should include activity" do
            expect(Activity.timeline(@activity.receiver, @activity.sender)).to include(@activity)
          end
        end

        context "for receiver" do
          it "should include activity" do
            expect(Activity.timeline(@activity.receiver, @activity.receiver)).to include(@activity)
          end
        end

        context "for Anonymous" do
          it "should include activity" do
            expect(Activity.timeline(@activity.receiver, nil)).to include(@activity)
          end
        end
      end

      describe "public timeline" do
        it "should include activity" do
          expect(Activity.timeline).to include(@activity)
        end
      end
    end
  end
end
