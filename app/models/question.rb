# frozen_string_literal: true

class Question < ApplicationRecord
  include Commentable
  validates :title, presence: true, length: { minimum: 2 }
  validates :body, presence: true, length: { minimum: 2 }

  belongs_to :user
  has_many :answers, dependent: :destroy
end
