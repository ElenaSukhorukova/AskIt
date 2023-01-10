class UserBulkImportJob < applicationJob
  queue_as :default
end