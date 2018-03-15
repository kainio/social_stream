class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
    def configure_permitted_parameters
      registration_params = [:name,:email, :password, :password_confirmation]
    
      if params[:action] == 'create'
        devise_parameter_sanitizer.for(:sign_up) do
          |u| u.permit(registration_params)
        end
      end
    end

end
