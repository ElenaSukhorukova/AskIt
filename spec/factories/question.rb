FactoryBot.define do
  factory :question do
    user { User.take || create(:user) }
    title { Faker::Hipster.sentence(word_count: 3) }
    body { Faker::Lorem.paragraph(sentence_count: 5, supplemental: true, random_sentences_to_add: 4) }
  end
end
