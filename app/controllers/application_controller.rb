class ApplicationController < ActionController::Base
  include Pagy::Backend
  include ErrorHandling
  include ApplicationHelper
  include Authentication

  add_flash_types :info, :danger, :warning, :success, :alert, :notice
  helper_method :current_user, :user_signed_in?
end
