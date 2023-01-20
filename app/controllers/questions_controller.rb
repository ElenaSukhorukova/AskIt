# frozen_string_literal: true

class QuestionsController < ApplicationController
  include QuestionsAnswers
  before_action :require_authentication, except: %i[index show]
  before_action :define_question!, except: %i[new create index]
  before_action :authorize_question!
  after_action :verify_authorized

  def index
    @pagy, @questions = pagy Question.all_by_tags(params[:tag_ids]), items: 4
    @questions = @questions.decorate

    @tags = Tag.where(id: params[:tag_ids]) if params[:tag_ids]
  end

  def show
    @answer = @question.answers.build
    @question = @question.decorate
    @pagy, @answers = pagy @question.answers.includes(:user).order(created_at: :desc), items: 3
    @answers = @answers.decorate

    @answer = add_answer_errors(@answer)
  end

  def new
    @question = current_user.questions.build
  end

  def edit; end

  def create
    @question = current_user.questions.build question_params

    if @question.save
      return redirect_to question_path(@question),
              success: t('flash.new', model: flash_for_locates(@question))
    end
    render :new, status: :unprocessable_entity
  end

  def update
    return unless @question.user == current_user

    if @question.update question_params
      return redirect_to question_path(@question),
              success: t('flash.update', model: flash_for_locates(@question))
    end
    render :edit, status: :unprocessable_entity
  end

  def destroy
    return unless @question.user == current_user
    return unless @question.destroy

    redirect_to questions_path,
                success: t('flash.destroy', model: flash_for_locates(@question))
  end

  private

  def define_question!
    @question = Question.find params[:id]
  end

  def add_answer_errors(answer)
    return answer unless session[:answer_errors]

    session[:answer_errors].each do |error, error_message|
      error_message.each do |msg|
        answer.errors.add error, msg
      end
    end
    session.delete :answer_errors

    answer
  end

  def authorize_question!
    authorize(@question || Question)
  end

  def question_params
    params.require(:question).permit(:title, :body, tag_ids: [], images: [])
  end
end
