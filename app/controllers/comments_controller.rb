# frozen_string_literal: true

class CommentsController < ApplicationController
  include QuestionsAnswers
  before_action :require_authentication
  before_action :set_commentable!, only: :create
  before_action :set_question, only: :create

  def create
    @comment = @commentable.comments.build comment_params

    if @comment.save
      return redirect_to question_path(@question),
                         success: I18n.t('flash.new', model: flash_for_locates(@comment))
    end

    session[:comment_errors] = @comment.errors if @comment.errors.any?
    @comment = @comment.decorate

    load_question_answers do_render: true
  end

  def destroy
    @comment = Comment.find params[:id]
    @question = @comment.commentable.is_a?(Question) ? @comment.commentable : @comment.commentable.question

    @comment.destroy
    redirect_to question_path(@question),
                success: I18n.t('flash.destroy', model: flash_for_locates(@comment))
  end

  private

  def comment_params
    params.require(:comment).permit(:body).merge(user: current_user)
  end

  def set_commentable!
    klass = [Question, Answer].detect { |c| params["#{c.name.underscore}_id"] }
    raise ActiveRecord::RecordNotFound if klass.blank?

    @commentable = klass.find(params["#{klass.name.underscore}_id"])
  end

  def set_question
    @question = @commentable.is_a?(Question) ? @commentable : @commentable.question
  end
end
