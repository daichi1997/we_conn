class ApplicationController < ActionController::Base
  before_action :basic_auth
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_new_matches_count, if: :user_signed_in?

  protected

  def after_sign_in_path_for(_resource)
    events_path
  end

  def after_sign_up_path_for(_resource)
    events_path
  end

  private

  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV['BASIC_AUTH_USER'] && password == ENV['BASIC_AUTH_PASSWORD'] # 環境変数を読み込む記述に変更
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :bio, :avatar])
  end

  def set_new_matches_count
    @new_matches_count = current_user.new_matches_count
  end
end
