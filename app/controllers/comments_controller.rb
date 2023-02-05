# frozen_string_literal: true

class CommentsController < ApplicationController
  include QuestionsAnswers
  before_action :require_authentication
  before_action :set_commentable!, only: :create
  before_action :set_question, only: :create
  before_action :authorize_comment!
  after_action :verify_authorized

  def create
    @comment = @commentable.comments.build comment_params
    @comment = @comment.decorate

    if @comment.save
      respond_to do |format|
        format.html do
          redirect_to question_path(@question),
                      success: I18n.t('flash.new', model: flash_for_locates(@comment))
        end
        format.turbo_stream do
          flash.now[:success] = t('flash.new', model: flash_for_locates(@comment))
        end
      end
    else
      load_question_answers do_render: true
    end
  end

  def destroy
    @comment = Comment.find params[:id]
    @question = @comment.commentable.is_a?(Question) ? @comment.commentable : @comment.commentable.question

    @comment.destroy
    respond_to do |format|
      format.html do
        redirect_to question_path(@question),
                    success: t('flash.destroy', model: flash_for_locates(@comment)),
                    status: :see_other
      end

      format.turbo_stream { flash.now[:success] = t('flash.destroy', model: flash_for_locates(@comment)) }
    end
  end

  private

  def set_commentable!
    klass = [Question, Answer].detect { |c| params["#{c.name.underscore}_id"] }
    raise ActiveRecord::RecordNotFound if klass.blank?

    @commentable = klass.find(params["#{klass.name.underscore}_id"])
  end

  def set_question
    @question = @commentable.is_a?(Question) ? @commentable : @commentable.question
  end

  def authorize_comment!
    authorize(@comment || Comment)
  end

  def comment_params
    params.require(:comment).permit(:body).merge(user: current_user)
  end
end
