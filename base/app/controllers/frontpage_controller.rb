class FrontpageController < ApplicationController
  include SocialStream::Devise::Controllers::UserSignIn

  before_action :redirect_user_to_home, :only => :index

  def index
    @resource = User.new
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  private

  def redirect_user_to_home
    redirect_to(home_path) if user_signed_in?
  end

end