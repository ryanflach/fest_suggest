require 'rails_helper'

RSpec.feature 'User logs in with Spotify' do
  context 'new user grants permission' do
    scenario 'they visit the root path' do
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

      expect(User.count).to eq(0)

      visit '/'
      click_on 'Login with Spotify'

      user = User.first

      expect(User.count).to eq(1)
      expect(user.username).to eq('test')
      expect(user.access_token).to eq('sample_token')
      expect(user.refresh_token).to eq('sample_refresh_token')
      expect(user.token_expiry)
        .to be_kind_of(ActiveSupport::TimeWithZone)
      expect(user.token_expiry > Time.now).to eq(true)
      expect(current_path).to eq(root_path)
      expect(page).to have_content('Successfully logged in.')
      expect(page).to have_content('Welcome, test!')
      expect(page).to have_link('Logout')
      expect(page).to_not have_link('Login with Spotify')
    end

    scenario 'existing user grants permissions' do
      create(:user)
      original_expiry = User.first.token_expiry

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

      expect(User.count).to eq(1)
      expect(User.first.username).to eq('test')
      expect(User.first.access_token).to eq('1234')
      expect(User.first.refresh_token).to eq('5678')

      visit '/'
      click_on 'Login with Spotify'

      user = User.first

      expect(User.count).to eq(1)
      expect(current_path).to eq(root_path)
      expect(user.username).to eq('test')
      expect(user.access_token).to eq('sample_token')
      expect(user.refresh_token).to eq('sample_refresh_token')
      expect(original_expiry < user.token_expiry).to eq(true)
      expect(current_path).to eq(root_path)
      expect(page).to have_content('Successfully logged in.')
      expect(page).to have_content('Welcome, test!')
      expect(page).to have_link('Logout')
      expect(page).to_not have_link('Login with Spotify')
    end
  end

  context 'user denies permission' do
    scenario 'they visit the root path' do
      params = {
        'error' => 'access_denied',
        'controller' => 'sessions',
        'action' => 'process_spotify_auth_response'
      }
      expected_flash_message =
        "Unable to authenticate with Spotify: #{params['error']}."

      allow_any_instance_of(SpotifyAuthController)
        .to receive(:spotify_login)
        .and_return(params)

      visit '/'
      click_on 'Login with Spotify'

      expect(current_path).to eq(root_path)
      expect(page).to have_content(expected_flash_message)
    end
  end
end
