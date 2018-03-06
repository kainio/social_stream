require 'rails_helper'

describe "Navigation" do
  include Capybara::DSL
  
  it "should be a valid app" do
    expect(::Rails.application).to be_a(Dummy::Application)
  end

  context "logged in" do
    before(:all) do
      @user = FactoryBot.create(:user)

      visit root_path
      fill_in 'user_email', :with => @user.email
      fill_in 'user_password', :with => 'testing123'

      click_button 'Sign in'
    end

    context "with other user" do
      before do
        FactoryBot.create(:user)
      end

      it "should close tab" do
        visit home_path
        click_link "x"

      end
    end
  end
end
