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

          format.zip { respond_with_zipped_users }
        end
      end

      def create
        UserBulkService.call params[:archive][:archive] if params[:archive].present?

        redirect_to admin_users_path, success: t('flash.imported')
      end

      def edit     
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

      def respond_with_zipped_users
        compressed_filestream = Zip::OutputStream.write_buffer do |zos|
          User.order(created_at: :desc).each do |user|
            zos.put_next_entry "user_#{user.id}.xlsx"
            zos.print render_to_string(
              layout: false, handlers: [:axlsx], formats: [:xlsx],
              template: 'admin/users/user',
              locals: { user: user }
            )
          end
        end
        compressed_filestream.rewind
        send_data compressed_filestream.read, filename: 'users.zip'
      end
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
      ).merge(admin_edit: true)
  end
end