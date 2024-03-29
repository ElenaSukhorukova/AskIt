# frozen_string_literal: true

module QuestionsAnswers
  extend ActiveSupport::Concern

  included do
    def load_question_answers(do_render: false)
      @question = @question.decorate
      @answer ||= @question.answers.build
      @pagy, @answers = pagy @question.answers.includes(:user).order(created_at: :desc), items: 3
      @answers = @answers.decorate
      render('questions/show', status: :unprocessable_entity) if do_render
    end
  end
end
