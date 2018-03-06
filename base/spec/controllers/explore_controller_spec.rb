require 'rails_helper'

describe ExploreController do
  render_views

  describe 'explore' do
    it "should render" do
      get :index

      expect(response).to be_success
    end
  end

  describe 'participants' do
    it "should render" do
      get :index, section: :participants

      expect(response).to be_success
    end
  end

  describe 'resources' do
    it "should render" do
      get :index, section: :resources

      expect(response).to be_success
    end
  end

  describe 'timeline' do
    before(:each) do
      FactoryBot.create(:public_activity)
    end

    it "should render" do
      get :index, section: 'timeline'

      expect(response).to be_success
    end
  end
end
