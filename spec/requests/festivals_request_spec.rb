require 'rails_helper'
include SpotifyHelper

RSpec.describe FestivalsController, type: :request do
  before(:all) { refresh_access_token if token_expired? }

  it 'returns festivals for long_term range' do
    VCR.use_cassette('festival_controller_long_term') do
      user = create(:user)

      allow_any_instance_of(ApplicationController)
        .to receive(:current_user)
        .and_return(user)

      get '/festivals?range=long_term'

      festivals = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(response.content_type).to eq('application/json')
      expect(festivals.first).to have_key('name')
      expect(festivals.first).to have_key('location')
      expect(festivals.first).to have_key('start_date')
      expect(festivals.first).to have_key('end_date')
      expect(festivals.first).to have_key('url')
      expect(festivals.first).to have_key('other_artists_count')
      expect(festivals.first).to_not have_key('id')
      expect(festivals.first).to_not have_key('created_at')
      expect(festivals.first).to_not have_key('updated_at')
      expect(festivals.first['top_artists'].first).to have_key('name')
      expect(festivals.first['rec_artists'].first).to have_key('name')
    end
  end

  it 'returns festivals for medium_term range' do
    VCR.use_cassette('festival_controller_medium_term') do
      user = create(:user)

      allow_any_instance_of(ApplicationController)
        .to receive(:current_user)
        .and_return(user)

      get '/festivals?range=medium_term'

      festivals = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(response.content_type).to eq('application/json')
      expect(festivals.first).to have_key('name')
      expect(festivals.first).to have_key('location')
      expect(festivals.first).to have_key('start_date')
      expect(festivals.first).to have_key('end_date')
      expect(festivals.first).to have_key('url')
      expect(festivals.first).to have_key('other_artists_count')
      expect(festivals.first).to_not have_key('id')
      expect(festivals.first).to_not have_key('created_at')
      expect(festivals.first).to_not have_key('updated_at')
      expect(festivals.first['top_artists'].first).to have_key('name')
      expect(festivals.first['rec_artists'].first).to have_key('name')
    end
  end

  it 'returns festivals for short_term range' do
    VCR.use_cassette('festival_controller_short_term') do
      user = create(:user)

      allow_any_instance_of(ApplicationController)
        .to receive(:current_user)
        .and_return(user)

      get '/festivals?range=short_term'

      festivals = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(response.content_type).to eq('application/json')
      expect(festivals.first).to have_key('name')
      expect(festivals.first).to have_key('location')
      expect(festivals.first).to have_key('start_date')
      expect(festivals.first).to have_key('end_date')
      expect(festivals.first).to have_key('url')
      expect(festivals.first).to have_key('other_artists_count')
      expect(festivals.first).to_not have_key('id')
      expect(festivals.first).to_not have_key('created_at')
      expect(festivals.first).to_not have_key('updated_at')
      expect(festivals.first['top_artists'].first).to have_key('name')
      expect(festivals.first['rec_artists'].first).to have_key('name')
    end
  end
end
