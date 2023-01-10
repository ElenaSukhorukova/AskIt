# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    username { 'Walter White' }
    email { "#{username.split.map(&:downcase).join('_')}@example.com" }
    password { '123Test123!+' }
  end
end
