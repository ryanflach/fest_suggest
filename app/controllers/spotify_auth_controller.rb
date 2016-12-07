class SpotifyAuthController < ApplicationController
  def spotify_user_auth
    redirect_to spotify_login
  end

  private

  def spotify_login
    'https://accounts.spotify.com/authorize/?' \
    "client_id=#{ENV['SPOTIFY_CLIENT']}&" \
    'response_type=code' \
    "&redirect_uri=#{ENV['SPOTIFY_REDIRECT']}&" \
    'scope=user-top-read playlist-modify-public'
  end
end
