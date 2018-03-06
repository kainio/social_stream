require 'rails_helper'

describe SettingsController do
  include SocialStream::TestHelpers
  render_views

  before do
    @user = FactoryBot.create(:user)
    @actor = @user.actor
    sign_in @user
  end

  it "should render index" do
    get :index
    expect(response).to be_success
  end

  it "should render index after update_all" do
    put :update_all
    expect(response).to redirect_to(:settings)
  end

  describe "Notification settings" do
    it "update notification email settings to Never" do
      @actor.update_attributes(:notify_by_email => true)
      expect(@actor.notify_by_email).to be true
      
      put :update_all, :settings_section => "notifications", :notify_by_email => "never"
      @actor.reload
      expect(@actor.notify_by_email).to be false

    end

    it "update notification email settings to Always" do
      @actor.update_attributes(:notify_by_email => false)
      expect(@actor.notify_by_email).to be false
      
      put :update_all, :settings_section => "notifications", :notify_by_email => "always"
      @actor.reload
      expect(@actor.notify_by_email).to be true
    end
  end
end
