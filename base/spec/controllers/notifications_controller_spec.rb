require 'rails_helper'


describe NotificationsController do
  include SocialStream::TestHelpers
  render_views

  before(:each) do
    @user = FactoryBot.create(:user)
    @actor =  @user.actor
    sign_in @user
    @receipt = @user.notify("subject", "body", FactoryBot.create(:activity))
  end

  it "should render index" do
    get :index
    expect(response).to be_success
  end

  it "should update read" do
    put :update, :id => @receipt.notification.to_param, :read => "Read"
    expect(@receipt.notification.is_unread?(@actor)).to be false
    expect(response).to be_success
  end

  it "should update unread" do
    put :update, :id => @receipt.notification.to_param, :read => "Unread"
    expect(@receipt.notification.is_unread?(@actor)).to be true
    expect(response).to be_success
  end

  it "should update all" do
    @receipt2 = @user.notify("subject", "body", FactoryBot.create(:activity))
    put :update_all
    expect(@receipt.notification.is_unread?(@actor)).to be false
    expect(@receipt2.notification.is_unread?(@actor)).to be false
    expect(response).to redirect_to(notifications_path)
  end
  
  it "should send to trash" do
    delete :destroy, :id => @receipt.notification.to_param
    expect(@receipt.notification.is_trashed?(@actor)).to be true
    expect(response).to be_success
  end

end
