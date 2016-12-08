require 'rails_helper'
include SpotifyHelper

RSpec.describe 'Spotify service' do
  before(:all) { refresh_access_tokens if token_expired? }

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

    it "gets a user's max top 25 artists for the last 4 weeks" do
      VCR.use_cassette('spotify_service_top_artists_short_term') do
        top_25 = Spotify::Service.new(ENV['ACCESS_TOKEN'])
                                 .top_25_artists('short_term')
        top_artist = top_25.first
        second_artist = top_25.second

        expect(top_25.length).to eq(22)
        expect(top_artist[:name]).to eq('Bon Iver')
        expect(second_artist[:name]).to eq('Tycho')
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
          .to eq('Wye Oak')
      end
    end
  end

  context '#create_playlist' do
    it 'creates a playlist and returns its Spotify ID' do
      VCR.use_cassette('spotify_service_create_playlist') do
        id = Spotify::Service.new(ENV['FS_ACCESS_TOKEN'])
                             .create_playlist('test')

        expect(id).to be_a(String)
      end
    end
  end

  context '#all_artist_ids' do
    it 'returns an array of Spotify IDs from a collection of names' do
      VCR.use_cassette('spotify_service_all_artist_ids') do
        artists = ['Sufjan Stevens', 'Ryan Flach', 'Team Sleep']
        ids = Spotify::Service.new(ENV['ACCESS_TOKEN'])
                              .all_artist_ids(artists)

        expect(ids).to be_a(Array)
        expect(ids.length).to eq(2)
        expect(ids.first).to eq('4MXUO7sVCaFgFjoTI5ox5c')
      end
    end
  end

  context '#each_artists_top_track' do
    it 'returns an array of one Spotify track URI for each ID' do
      VCR.use_cassette('spotify_service_each_artists_top_track') do
        ids = ['4MXUO7sVCaFgFjoTI5ox5c', '6CwDvApcRshxhEVMP30Sq7']
        uris = Spotify::Service.new(ENV['ACCESS_TOKEN'])
                               .each_artists_top_track(ids)

        expect(uris).to be_a(Array)
        expect(uris.length).to eq(2)
        expect(uris.first).to eq('spotify:track:6Rt6KwuF7I8ZkdZG2G0bYr')
      end
    end
  end

  context '#add_tracks_to_playlist' do
    it 'adds tracks from Spotify URIs to an existing playlist' do
      VCR.use_cassette('spotify_service_add_tracks_to_playlist') do
        service = Spotify::Service.new(ENV['FS_ACCESS_TOKEN'])
        playlist_id = service.create_playlist('test')
        artist_ids = [
          '4MXUO7sVCaFgFjoTI5ox5c',
          '6CwDvApcRshxhEVMP30Sq7'
        ]
        track_uris = service.each_artists_top_track(artist_ids)
        response =
          service.add_tracks_to_playlist(playlist_id, track_uris)
        playlist = Typhoeus::Request.new(
          "#{service.instance_variable_get('@base_url')}/v1/users/" \
          "#{ENV['FS_ADMIN_NAME']}/playlists/#{playlist_id}/tracks",
          headers: service.instance_variable_get('@headers')
        ).run
        tracks_on_playlist = JSON.parse(
          playlist.response_body, symbolize_names: true
        )[:items]

        expect(response).to be_a(Hash)
        expect(tracks_on_playlist.length).to eq(2)
        expect(tracks_on_playlist.first[:track][:uri])
          .to eq(track_uris.first)
      end
    end
  end
end
