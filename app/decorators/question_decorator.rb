# frozen_string_literal: true

class QuestionDecorator < ApplicationDecorator
  decorates_association :user
  decorates_finders
  delegate_all
end
