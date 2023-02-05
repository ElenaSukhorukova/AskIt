# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :require_no_authentication, only: %i[new create]
  before_action :require_authentication, only: :destroy

  def new; end

  def create
    debugger
    user = User.find_by email: params[:email]
    if user&.authenticate(params[:password])
      do_sign_in user
    else
      render :new, status: :unprocessable_entity
      flash[:warning] = I18n.t('flash.session_error')
    end
  end

  def destroy
    sign_out
    redirect_to root_path,
                success: I18n.t('flash.session_destroy')
  end

  private

  def do_sign_in(user)
    sign_in user
    remember(user) if params[:remember_me] == '1'
    redirect_to root_path,
                success: I18n.t('flash.session_success', username: current_user.name_or_email)
  end
end
