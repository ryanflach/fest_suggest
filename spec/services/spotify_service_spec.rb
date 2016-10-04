require 'rails_helper'
include SpotifyHelper

RSpec.describe 'Spotify service' do
  before(:all) { refresh_access_token if token_expired? }

  context '#get_username' do
    it "gets a user's username" do
      VCR.use_cassette('spotify_service_get_username') do
        username = Spotify::Service.new(ENV['ACCESS_TOKEN'])
                                   .get_username

        expect(username).to eq(ENV['SPOTIFY_USERNAME'])
      end
    end
  end

  context '#top_25_artists' do
    it "gets a user's top 25 artists for all time" do
      VCR.use_cassette('spotify_service_top_artists_long_term') do
        top_25 = Spotify::Service.new(ENV['ACCESS_TOKEN'])
                                 .top_25_artists('long_term')
        top_artist = top_25.first
        second_artist = top_25.second

        expect(top_25.length).to eq(25)
        expect(top_artist[:name]).to eq('Sufjan Stevens')
        expect(second_artist[:name]).to eq('Weatherbox')
      end
    end

    it "gets a user's top 25 artists for the last 6 months" do
      VCR.use_cassette('spotify_service_top_artists_med_term') do
        top_25 = Spotify::Service.new(ENV['ACCESS_TOKEN'])
                                 .top_25_artists('medium_term')
        top_artist = top_25.first
        second_artist = top_25.second

        expect(top_25.length).to eq(25)
        expect(top_artist[:name]).to eq('Sufjan Stevens')
        expect(second_artist[:name]).to eq('Local Natives')
      end
    end

    it "gets a user's top 25 artists for the last 4 weeks" do
      VCR.use_cassette('spotify_service_top_artists_short_term') do
        top_25 = Spotify::Service.new(ENV['ACCESS_TOKEN'])
                                 .top_25_artists('short_term')
        top_artist = top_25.first
        second_artist = top_25.second

        expect(top_25.length).to eq(25)
        expect(top_artist[:name]).to eq('Local Natives')
        expect(second_artist[:name]).to eq('Frank Ocean')
      end
    end
  end

  context '#recommended_artists' do
    it "gets a user's recommended artists" do
      VCR.use_cassette('spotify_service_recommended_artists') do
        artist_ids = "4MXUO7sVCaFgFjoTI5ox5c," \
                     "39vm4qt0PqnZrJOoA9FXTD," \
                     "5SjNVG3L9mgWQPsfp1sFDB," \
                     "0IlQRCafsMrd0QkTRBU6n0," \
                     "7z1QgLoFoyVn2Ra22w8Wzo"
        recommended = Spotify::Service.new(ENV['ACCESS_TOKEN'])
                                      .recommended_artists(artist_ids)

        expect(recommended.length).to eq(100)
        expect(recommended.first[:artists].first[:name])
          .to eq('Sufjan Stevens')
      end
    end
  end
end
