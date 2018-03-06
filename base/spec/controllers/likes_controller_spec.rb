require 'rails_helper'

describe LikesController do
  render_views

  it "should create like" do
    @activity = Factory(:activity)
    @subject  = @activity.receiver_subject

    sign_in @subject

    post :create, :activity_id => @activity.id

    assert @activity.liked_by?(@subject)
  end

  it "should destroy like" do
    @like_activity = Factory(:like_activity)
    @activity = @like_activity.parent
    @subject =  @like_activity.sender_subject

    sign_in @subject

    delete :destroy, :activity_id => @activity.id

    assert ! @activity.liked_by?(@subject)
  end

  it "should create, destroy and create it again" do
    @activity = Factory(:activity)
    @subject  = @activity.receiver_subject

    sign_in @subject

    post :create, :activity_id => @activity.id

    assert @activity.liked_by?(@subject)

    delete :destroy, :activity_id => @activity.id

    assert ! @activity.liked_by?(@subject)

    post :create, :activity_id => @activity.id

    assert @activity.liked_by?(@subject)
  end
end

