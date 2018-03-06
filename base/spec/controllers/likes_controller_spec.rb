require 'rails_helper'

describe LikesController do
  render_views

  it "should create like" do
    @activity = FactoryBot.create(:activity)
    @subject  = @activity.receiver_subject

    sign_in @subject

    post :create, :activity_id => @activity.id, format: :js

    expect(@activity.liked_by?(@subject)).to be true
  end

  it "should destroy like" do
    @like_activity = FactoryBot.create(:like_activity)
    @activity = @like_activity.parent
    @subject =  @like_activity.sender_subject

    sign_in @subject

    delete :destroy, :activity_id => @activity.id, format: :js

    expect(! @activity.liked_by?(@subject)).to be true
  end

  it "should create, destroy and create it again" do
    @activity = FactoryBot.create(:activity)
    @subject  = @activity.receiver_subject

    sign_in @subject

    post :create, :activity_id => @activity.id, format: :js

    expect(@activity.liked_by?(@subject)).to be true

    delete :destroy, :activity_id => @activity.id , format: :js

    expect(! @activity.liked_by?(@subject)).to be true

    post :create, :activity_id => @activity.id, format: :js

    expect(@activity.liked_by?(@subject)).to be true
  end
end

