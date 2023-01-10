# frozen_string_literal: true

class PasswordResetsController < ApplicationController
  before_action :require_no_authentication
  before_action :check_user_params, only: %i[edit update]
  before_action :set_user, only: %i[edit update]

  def edit; end

  def create
    @user = User.find_by email: params[:email]
    if @user.present?
      @user.set_password_reset_token
      PasswordResetMailer.with(user: @user).reset_email.deliver_later
    end
    flash[:success] = t 'flash.instructions_were_sent'
    redirect_to new_session_path
  end

  def update
    if @user.update user_params
      return redirect_to new_session_path,
                         success: t('.updated')
    end
    render :edit, status: :unprocessable_entity
  end

  private

  def check_user_params
    redirect_to(new_session_path, flash: { warning: t('.fail') }) if params[:user].blank?
  end

  def set_user
    @user = User.find_by email: params[:user][:email],
                         password_reset_token: params[:user][:password_reset_token]
    return if @user&.password_reset_period_valid?

    redirect_to new_session_path,
                warning: t('.fail')
  end

  def user_params
    params.require(:user).permit(:password, :password_confirmation).merge(skip_all_password: true)
  end
end
