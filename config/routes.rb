Rails.application.routes.draw do
  root 'home#index'

  get '/spotify_login',
      to: 'spotify_auth#spotify_user_auth',
      as: 'spotify_login'
  get '/auth/spotify/callback',
      to: 'sessions#process_spotify_auth_response'
  delete '/logout', to: 'sessions#destroy', as: :logout
  resources :festivals, only: [:index], defaults: { format: 'json' }
  resources :artists, only: [:index], defaults: { format: 'json' }
  resources :playlists,
    only: [:show, :update],
    param: :name,
    defaults: { format: 'json' }
end
