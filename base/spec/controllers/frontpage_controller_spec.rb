require 'rails_helper'

describe FrontpageController do
  render_views

  it "should render index" do
    get :index
    expect(response).to be_success
  end
end

