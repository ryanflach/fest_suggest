require 'rails_helper'
include SpotifyHelper

RSpec.describe ArtistsController, type: :request do
  before(:all) { refresh_access_token if token_expired? }

  it 'returns artists for long_term range' do
    VCR.use_cassette('artist_controller_long_term') do
      user = create(:user)

      allow_any_instance_of(ApplicationController)
        .to receive(:current_user)
        .and_return(user)

      get '/artists?range=long_term'

      artists = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(response.content_type).to eq('application/json')
      expect(artists.first['name']).to eq('Sufjan Stevens')
      expect(artists.first).to_not have_key('id')
      expect(artists.first).to_not have_key('created_at')
      expect(artists.first).to_not have_key('updated_at')
    end
  end

  it 'returns artists for medium_term range' do
    VCR.use_cassette('artist_controller_medium_term') do
      user = create(:user)

      allow_any_instance_of(ApplicationController)
        .to receive(:current_user)
        .and_return(user)

      get '/artists?range=medium_term'

      artists = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(response.content_type).to eq('application/json')
      expect(artists.first['name']).to eq('Sufjan Stevens')
      expect(artists.first).to_not have_key('id')
      expect(artists.first).to_not have_key('created_at')
      expect(artists.first).to_not have_key('updated_at')
    end
  end

  it 'returns artists for short_term range' do
    VCR.use_cassette('artist_controller_short_term') do
      user = create(:user)

      allow_any_instance_of(ApplicationController)
        .to receive(:current_user)
        .and_return(user)

      get '/artists?range=short_term'

      artists = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(response.content_type).to eq('application/json')
      expect(artists.first['name']).to eq('Local Natives')
      expect(artists.first).to_not have_key('id')
      expect(artists.first).to_not have_key('created_at')
      expect(artists.first).to_not have_key('updated_at')
    end
  end
end
