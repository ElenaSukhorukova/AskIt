# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    user { User.take || create(:user) }
    body { 'Answer\'s body' }
    question { Question.take || create(:question) }
  end
end
