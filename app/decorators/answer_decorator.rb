class AnswerDecorator < ApplicationDecorator
  decorates_association :user
  decorates_finders
  delegate_all
  
  def formatted_created_at
    created_at.strftime('%Y-%m-%d %H:%M:%S')
  end
end
