# frozen_string_literal: true

(5 - User.count).times do |index|
  username = [Faker::Address.full_address, ''].sample
  email = "email#{index + 1}@email.com"
  password = '123Test123!'

  User.create username: username, email: email, password: password
end

(10 - Question.count).times do
  user_id = User.ids.sample
  title = Faker::Hipster.sentence(word_count: 3)
  body = Faker::Lorem.paragraph(sentence_count: 5, supplemental: true, random_sentences_to_add: 4)

  Question.create title: title, body: body, user_id: user_id unless Question.find_by(title: title, body: body)
end

Question.all.each do |question|
  (10 - Answer.where(question_id: question.id).count).times do
    user_id = User.ids.sample
    question_id = question.id
    body = Faker::Lorem.paragraph(sentence_count: 5, supplemental: true, random_sentences_to_add: 4)

    Answer.create body: body, user_id: user_id, question_id: question_id
  end
end

User.find_each do |u|
  u.send(:set_gravatar_hash)
  u.save
end
