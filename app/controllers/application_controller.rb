class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user,
                :refresh_expired_token

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def site_admin
    @site_admin ||= User.site_admin
  end

  def refresh_expired_tokens
    UserEngine.update_user(current_user)
    UserEngine.update_user(site_admin)
  end
end
