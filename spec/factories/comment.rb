# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    user { User.take || create(:user) }
    body { 'Comment\'s body' }
    association :commentable, factory: %i[answer question].sample
  end
end
