class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user,
                :refresh_expired_token

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def refresh_expired_token
    if current_user && current_user.token_expiry < Time.now
      tokens = Spotify::AuthService.new
                                   .refresh_user_tokens(
                                     current_user.refresh_token
                                   )
      current_user.update(tokens)
    end
  end
end
