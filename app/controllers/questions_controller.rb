class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :define_user, only: %i[new create]
  before_action :define_question, except: %i[new create index]
  helper_method :model_name

  def index
    @questions = Question.all
  end

  def show
  end

  def new
    @question = @user.questions.build
  end

  def create
    @question = @user.questions.build(question_params)

    if @question.save
      redirect_to questions_path, success: I18n.t('flash.new', model: model_name.downcase)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @question.update(question_params)
      redirect_to questions_path, success: I18n.t('flash.update', model: model_name.downcase)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @question.destroy
      redirect_to questions_path, success: I18n.t('flash.destroy', model: model_name.downcase)
    end
  end

  private

    def model_name
      Question.model_name.human
    end

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
