# frozen_string_literal: true

class AnswersController < ApplicationController
  include ActionView::RecordIdentifier
  include QuestionsAnswers

  before_action :require_authentication
  before_action :define_variables!, only: %i[create]
  before_action :define_answer!, only: %i[edit update destroy]
  before_action :authorize_answer!
  after_action :verify_authorized

  def edit; end

  def create
    @answer = @question.answers.build answer_create_params
    @question = @question.decorate
    if @answer.save
      redirect_to question_path(@question, anchor: dom_id(@answer)),
                  success: I18n.t('flash.new', model: flash_for_locates(@answer))
    else
      session[:answer_errors] = @answer.errors if @answer.errors.any?
      load_question_answers do_render: true
    end
  end

  def update
    return unless @answer.user == current_user

    if @answer.update answer_update_params
      redirect_to question_path(@answer.question),
                  success: I18n.t('flash.update', model: flash_for_locates(@answer))
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    return unless @answer.user == current_user
    return unless @answer.destroy

    redirect_to question_path(@answer.question),
                success: I18n.t('flash.destroy', model: flash_for_locates(@answer))
  end

  private

  def define_variables!
    @question = Question.find params[:question_id]
    @user = current_user.decorate
  end

  def define_answer!
    @answer = Answer.find params[:id]
  end

  def authorize_answer!
    authorize(@answer || Answer)
  end

  def answer_create_params
    params.require(:answer).permit(:body).merge(user: current_user)
  end

  def answer_update_params
    params.require(:answer).permit(:body)
  end
end
