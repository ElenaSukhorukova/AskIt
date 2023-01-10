# frozen_string_literal: true

class UserBulkImportJob < applicationJob
  queue_as :default
end
