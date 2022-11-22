class QuestionsController < ApplicationController
  def index
    @qustions = Question.all
  end
end
