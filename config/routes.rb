Rails.application.routes.draw do
  root 'home#index'

  get '/spotify_login',
      to: 'spotify_auth#spotify_user_auth',
      as: 'spotify_login'
  get '/auth/spotify/callback',
      to: 'sessions#process_spotify_auth_response'
  delete '/logout', to: 'sessions#destroy', as: :logout
end
