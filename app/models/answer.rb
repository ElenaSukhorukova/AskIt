# frozen_string_literal: true

class Answer < ApplicationRecord
  include TimeShow

  validates :body, presence: true, length: { minimum: 5 }

  belongs_to :question
  belongs_to :user
end
