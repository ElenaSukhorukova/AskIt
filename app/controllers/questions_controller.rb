class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :define_user, only: %i[new create]
  before_action :define_article, except: %i[new create index]
  before_action do 
    @model_name = Artcile.model_name.human
  end

  def index
    @questions = Articles.all
  end

  def show
  end

  def new
    @article = @user.articles.build
  end

  def create
    @article = @user.articles.build(article_params)

    if @question.save
      redirect_to articles_path, success: I18n.t('flash.new', model: @model_name.downcase)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @article.update(article_params)
      redirect_to questions_path, success: I18n.t('flash.update', model: @model_name.downcase)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @article.destroy
      redirect_to articles_path, success: I18n.t('flash.destroy', model: @model_name.downcase)
    end
  end

  private

    def define_user
      @user = User.find(params[:user_id])
    end

    def define_question
      @article = Article.find(params[:id])
    end

    def article_params
      params.require(:article).permit(:title, :content, :status)
    end
end
