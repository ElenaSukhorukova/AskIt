# frozen_string_literal: true

FactoryBot.define do
  factory :question_tag do
    tag { Tag.take || create(:tag) }
    question { Question.take || create(:question) }
  end
end
