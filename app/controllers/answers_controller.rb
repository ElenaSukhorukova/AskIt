class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :define_variables!, only: %i[create]
  before_action :define_answer, only: %i[edit update destroy]
  include ApplicationHelper

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = @user 

    if @answer.save
      redirect_to question_path(@question),
        success: I18n.t('flash.new', model: i18n_model_name(@answer).downcase)
    else
      redirect_to question_path(@question), 
        danger: "#{@answer.errors.full_messages.each{|error| error.capitalize}.join(' ')}"
    end
  end

  def edit
  end

  def update
    if @answer.user == current_user
      if @answer.update(answer_params)
        redirect_to question_path(@answer.question),
          success: I18n.t('flash.update', model: i18n_model_name(@answer).downcase)
      else
        redirect_to question_path(@answer.question), 
          danger: "#{@answer.errors.full_messages.each{|error| error.capitalize}.join(' ')}"
      end
    end
  end

  def destroy
    if @answer.user == current_user
      if @answer.destroy
        redirect_to question_path(@answer.question),
        success: I18n.t('flash.destroy', model: i18n_model_name(@answer).downcase)
      end
    end
  end

  private
    def define_answer
      @answer = Answer.find(params[:id])
    end

    def define_variables!
      @question = Question.find(params[:question_id])
      @user = current_user
    end

    def answer_params
      params.require(:answer).permit(:body)
    end
end
