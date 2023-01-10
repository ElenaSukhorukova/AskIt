FactoryBot.define do
  factory :user do
    username { Faker::Name.name }
    email { "#{username.split(' ').map(&:downcase).join('_')}@example.com" }
    password { '123Test123!+' }
  end
end
