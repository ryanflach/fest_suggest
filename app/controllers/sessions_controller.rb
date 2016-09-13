class SessionsController < ApplicationController
  def create
    user = User.process_spotify_user(@user_data)
    session[:user_id] = user.id
    flash[:success] = 'Successfully logged in.'
    redirect_to root_path
  end

  def destroy
    session.clear
    flash[:success] = 'Logged out. Thanks for visiting!'
    redirect_to root_path
  end

  def process_spotify_auth_response
    if params[:code]
      process_user_login
    else
      flash[:danger] =
        "Unable to authenticate with Spotify: #{params[:error]}."
      redirect_to root_path
    end
  end

  private

  def process_user_login
    tokens     = Spotify::AuthService.new(params[:code]).process_auth
    username   = Spotify::Service.new(tokens[:access_token])
                                     .get_username
    @user_data = format_user_data(tokens, username)
    create
  end

  def format_user_data(tokens, username)
    {
      username: username,
      access_token: tokens[:access_token],
      refresh_token: tokens[:refresh_token],
      token_expiry: tokens[:token_expiry]
    }
  end
end
