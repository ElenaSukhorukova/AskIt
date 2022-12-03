class QuestionsController < ApplicationController
  include ApplicationHelper
  before_action :authenticate_user!, except: %i[index show]
  before_action :define_user, only: %i[new create]
  before_action :define_question, except: %i[new create index]

  def index
    @questions = Question.all.order(created_at: :desc)
  end

  def show
    @answer = @question.answers.build
    @answers = @question.answers.order(created_at: :desc)
  end

  def new
    @question = @user.questions.build
  end

  def create
    @question = @user.questions.build(question_params)

    if @question.save
      redirect_to question_path(@question), 
        success: I18n.t('flash.new', model: i18n_model_name(@question).downcase)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @question.user == current_user
      if @question.update(question_params)
        redirect_to questions_path, 
          success: I18n.t('flash.update', model: i18n_model_name(@question).downcase)
      else
        render :edit, status: :unprocessable_entity
      end
    end
  end

  def destroy
    if @question.user == current_user
      if @question.destroy
        redirect_to questions_path, 
          success: I18n.t('flash.destroy', model: i18n_model_name(@question).downcase)
      end
    end
  end

  private

    def define_user
      @user = User.find(params[:user_id])
    end

    def define_question
      @question = Question.find(params[:id])
    end

    def question_params
      params.require(:question).permit(:title, :body)
    end
end
