class SessionsController < ApplicationController
  before_action :require_no_authentication, only: %i[new create]
  before_action :require_authentication, only: :destroy

  def new; end

  def create
    user = User.find_by email: params[:session][:email]
    if user&.authenticate(params[:session][:password])
      sign_in user
      remember(user) if params[:remember_me] == '1'
      redirect_to root_path,
                  success: I18n.t('flash.session_success', username: current_user.name_or_email)
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
end
