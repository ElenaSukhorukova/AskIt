class UsersController < ApplicationController
  before_action :require_no_authentication, only: %i[new create]
  before_action :require_authentication, except: %i[new create]
  before_action :set_user!, except: %i[new create]

  def new
    @user = User.new
  end

  def edit; end

  def create
    render plain: params.to_yaml and return
    @user = User.new user_params
    if @user.save
      sign_in @user
      redirect_to root_path,
                  success: I18n.t('flash.registration', username: current_user.name_or_email)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @user.update user_params
      redirect_to root_path,
                  success: I18n.t('flash.update', model: i18n_model_name(@user).downcase)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user!
    @user = User.find params[:id]
  end

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :old_password)
  end
end
