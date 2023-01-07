module Admin
  class BaseController < ApplicationController
    def authorize(record, query = nil)
      super(record, query)
    end
  end
end