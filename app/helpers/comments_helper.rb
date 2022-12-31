# frozen_string_literal: true

module CommentsHelper
  def add_comment_errors(comment)
    return comment unless session[:comment_errors]

    session[:comment_errors].each do |error, error_message|
      error_message.each do |msg|
        comment.errors.add error, msg
      end
    end
    session.delete :comment_errors

    comment
  end
end
