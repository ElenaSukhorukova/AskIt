class ApplicationController < ActionController::Base
  include ErrorHandling
  include ApplicationHelper
  before_action :configure_permitted_parameters, if: :devise_controller?

  add_flash_types :info, :danger, :warning, :success, :alert, :notice

  protected  

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    end
end
