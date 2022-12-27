# frozen_string_literal: true

class AnswerDecorator < ApplicationDecorator
  decorates_association :user
  decorates_finders
  delegate_all
end
