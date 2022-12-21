# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :require_authentication
  include ActionView::RecordIdentifier
  before_action :define_variables!, only: %i[create]
  before_action :define_answer!, only: %i[edit update destroy]

  def edit; end

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = @user

    if @answer.save
      redirect_to question_path(@question, anchor: dom_id(@answer)),
                  success: I18n.t('flash.new', model: i18n_model_name(@answer).downcase)
    else
      redirect_to question_path(@question),
                  danger: @answer.errors.full_messages.each(&:capitalize).join(' ').to_s
    end
  end

  def update
    return unless @answer.user == current_user

    if @answer.update(answer_params)
      redirect_to question_path(@answer.question),
                  success: I18n.t('flash.update', model: i18n_model_name(@answer).downcase)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    return unless @answer.user == current_user
    return unless @answer.destroy

    redirect_to question_path(@answer.question),
                success: I18n.t('flash.destroy', model: i18n_model_name(@answer).downcase)
  end

  private

  def define_variables!
    @question = Question.find(params[:question_id])
    @user = current_user.decorate
  end

  def define_answer!
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
