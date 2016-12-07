require 'rails_helper'

RSpec.feature 'User persists login after token expires' do
  scenario 'logged-in user with expired token visits the root path' do
    user = create(:user, token_expiry: Time.now)

    formatted_token_response = {
      access_token: 'new_token',
      refresh_token: 'new_refresh',
      token_expiry: '2016-09-11 22:33:08'
    }

    allow_any_instance_of(ApplicationController)
      .to receive(:current_user)
      .and_return(user)

    allow_any_instance_of(Spotify::AuthService)
      .to receive(:refresh_user_tokens)
      .and_return(formatted_token_response)

    visit '/'

    expect(page).to have_link('X')
    expect(page).to_not have_link('Login with Spotify')
    expect(User.count).to eq(2)
    expect(User.last.access_token).to eq('new_token')
    expect(User.last.refresh_token).to eq('new_refresh')
    expect(User.last.token_expiry).to eq('2016-09-11 22:33:08')
  end
end
