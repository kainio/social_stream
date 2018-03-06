require 'rails_helper'

describe "ResqueAccess" do
  context "with config enabled" do
    before do
      SocialStream.resque_access = true
    end

    it "should be success" do
      get '/resque/overview'

      expect(response).to be_success
    end
  end

  context "with config disabled" do
    before do
      SocialStream.resque_access = false
    end

    it "should be success" do
      begin
        get '/resque/overview'
        assert false
      rescue ActionController::RoutingError
        assert true
      end
    end
  end
end
