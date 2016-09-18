require 'rails_helper'

RSpec.feature 'User logs out' do
  scenario 'logged-in user visits the root path' do
    login

    visit '/'

    expect(page).to have_link('X')

    click_on 'X'

    expect(page).to have_link('Login with Spotify')
    expect(page).to_not have_link('X')
  end
end

def login
  params = {
    'code' => 'sample_code',
    'controller' => 'sessions',
    'action' => 'process_spotify_auth_response'
  }

  parsed_token_data = {
    access_token: 'sample_token',
    token_type: 'Bearer',
    expires_in: 3600,
    refresh_token: 'sample_refresh_token',
    scope: 'user-top-read'
  }

  parsed_user_data = {
    display_name: nil,
    external_urls: {
      spotify: 'https://open.spotify.com/user/test'
    },
    followers: { href: nil, total: 1 },
    href: 'https://api.spotify.com/v1/users/test',
    id: 'test',
    images: [],
    type: 'user',
    uri: 'spotify:user:test'
  }

  allow_any_instance_of(SpotifyAuthController)
    .to receive(:spotify_login)
    .and_return(params)

  allow_any_instance_of(Spotify::AuthService)
    .to receive(:retrieve_user_tokens)
    .and_return(parsed_token_data)

  allow_any_instance_of(Spotify::Service)
    .to receive(:request_user_data)
    .and_return(parsed_user_data)

  visit '/'
  click_on 'Login with Spotify'
end
