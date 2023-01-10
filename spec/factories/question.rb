# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    user { User.take || create(:user) }
    title { "Question's title" }
    body { "Question's body" }
  end
end
