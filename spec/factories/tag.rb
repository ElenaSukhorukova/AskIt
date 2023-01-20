# frozen_string_literal: true

FactoryBot.define do
  factory :tag do
    title { "tag's name #{Faker::Alphanumeric.alpha(number: 1)}" }
  end
end
