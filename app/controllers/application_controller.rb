# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pagy::Backend
  include ErrorHandling
  include ApplicationHelper
  include Authentication
  include Internationalization

  add_flash_types :info, :danger, :warning, :success, :alert, :notice
end
