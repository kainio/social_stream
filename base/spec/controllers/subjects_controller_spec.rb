require 'rails_helper'

describe SubjectsController, pending: "unimplemented" do
  render_views

  it "should redirect lrdd" do
    @user = FactoryBot.create(:user)

    get :lrdd, :id => "#{ @user.slug }@test.host"

    expect(response).to redirect_to(user_path(@user, :format => :xrd))
  end
end

