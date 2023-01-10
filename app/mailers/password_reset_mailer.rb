# frozen_string_literal: true

class PasswordResetMailer < ApplicationMailer
  def reset_email
    @user = params[:user]
    mail to: @user.email, subject: t('password_reset_mailer.reset_email.subject')
  end
end
