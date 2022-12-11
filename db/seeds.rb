30.times do
  user_id = [1, 2].sample
  title = Faker::Hipster.sentence(word_count: 3)
  body = Faker::Lorem.paragraph(sentence_count: 5, supplemental: true, random_sentences_to_add: 4)
  
  unless Question.find_by(title: title, body: body)
    Question.create title: title, body: body, user_id: user_id
  end
end

60.times do
  user_id = [1, 2].sample
  question_id = Question.ids.sample
  body = Faker::Lorem.paragraph(sentence_count: 5, supplemental: true, random_sentences_to_add: 4)

  unless Answer.find_by body: body, question_id: question_id
    Answer.create body: body, user_id: user_id, question_id: question_id
  end
end