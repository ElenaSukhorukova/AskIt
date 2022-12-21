class QuestionsController < ApplicationController
  before_action :require_authentication, except: %i[index show]
  before_action :define_user!, only: %i[new create]
  before_action :define_question!, except: %i[new create index]

  def index
    @pagy, @questions = pagy Question.order(created_at: :desc), items: 4
    @questions = @questions.decorate
  end

  def show
    @question = @question.decorate
    @answer = @question.answers.build
    @pagy, @answers = pagy @question.answers.order(created_at: :desc), items: 3
    @answers = @answers.decorate
  end

  def new
    @question = @user.questions.build
  end

  def edit; end

  def create
    @question = @user.questions.build question_params

    if @question.save
      redirect_to question_path(@question),
                  success: I18n.t('flash.new', model: i18n_model_name(@question).downcase)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    return unless @question.user == current_user

    if @question.update question_params
      redirect_to questions_path,
                  success: I18n.t('flash.update', model: i18n_model_name(@question).downcase)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    return unless @question.user == current_user
    return unless @question.destroy

    redirect_to questions_path,
                success: I18n.t('flash.destroy', model: i18n_model_name(@question).downcase)
  end

  private

  def define_user!
    @user = User.find params[:user_id]
  end

  def define_question!
    @question = Question.find params[:id]
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
