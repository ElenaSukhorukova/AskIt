# frozen_string_literal: true

class Question < ApplicationRecord
  include Commentable
  include Authorship

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :question_tags, dependent: :destroy
  has_many :tags, through: :question_tags

  validates :title, presence: true, length: { minimum: 2 }
  validates :body, presence: true, length: { minimum: 2 }

  scope :all_by_tags, lambda { |tags|
    questions = includes(:user, :question_tags, :tags)
    questions = if tags
                  questions.joins(:tags).where(tags: tags).preload(:tags)
                else
                  questions.includes(:question_tags, :tags)
                end
    questions.order(created_at: :desc)
  }
end
