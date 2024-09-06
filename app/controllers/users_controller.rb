class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  before_action :ensure_correct_user, only: [:edit, :update]

  def show
    @name = @user.name
    @events = @user.events
  end

  def edit
  end

  def update
    if user_params[:password].blank?
      user_params.delete(:password)
      user_params.delete(:password_confirmation)
    end

    successfully_updated = if needs_password?(@user, user_params)
                             @user.update(user_params)
                           else
                             @user.update_without_password(user_params)
                           end

    if successfully_updated
      redirect_to @user, notice: '更新しました。'
    else
      puts "Update failed. Errors: #{@user.errors.full_messages}"
      render :edit
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def ensure_correct_user
    return if @user == current_user

    redirect_to root_path, alert: '権限がありません。'
  end

  def user_params
    params.require(:user).permit(:name, :bio, :password, :password_confirmation)
  end

  def needs_password?(_user, params)
    params[:password].present?
  end
end
