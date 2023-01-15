# frozen_string_literal: true

module Admin
  class UsersController < BaseController
    before_action :require_authentication
    before_action :set_user!, only: %i[edit update destroy]
    before_action :authorize_user!
    after_action :verify_authorized

    def index
      respond_to do |format|
        format.html do
          @pagy, @users = pagy User.order(created_at: :desc)
          @users = @users.decorate
        end

        format.zip do 
          UserBulkExportJob.perform_later current_user
          redirect_to admin_users_path, success: t('.success')
        end
      end
    end

    def edit; end

    def create
      return unless params[:archive]
      UserBulkImportJob.perform_later create_blob, current_user

      redirect_to admin_users_path, success: t('flash.imported')
    end

    def update
      if @user.update user_params
        redirect_to admin_users_path,
                    success: I18n.t('flash.update', model: flash_for_locates(@user))
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @user.destroy
      redirect_to admin_users_path,
                  success: I18n.t('flash.destroy', model: flash_for_locates(@user))
    end

    private

    def create_blob
      file = File.open params[:archive][:archive]
      result = ActiveStorage::Blob.create_and_upload! io: file,
                                                      filename: params[:archive][:archive].original_filename
      file.close
      result.key 
    end

    def set_user!
      @user = User.find params[:id]
    end

    def authorize_user!
      authorize(@user || User)
    end

    def user_params
      params.require(:user).permit(
        :username, :email, :password, :password_confirmation, :role
      ).merge(skip_all_password: true)
    end
  end
end
