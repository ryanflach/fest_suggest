require 'rails_helper'
include SpotifyHelper

describe Artist do
  before(:all) { refresh_access_token if token_expired? }

  it "gets a user's top artists with complete profiles" do
    VCR.use_cassette('artist_top_artists_complete') do
      user = create(
        :user,
        access_token: ENV['ACCESS_TOKEN'],
        refresh_token: ENV['REFRESH_TOKEN'],
        token_expiry: ENV['TOKEN_EXPIRY']
      )

      top_artists = Artist.top_artists_complete(user, 'long_term')
      top_artist = top_artists.first

      expect(top_artists.length).to eq(25)
      expect(top_artist.name).to eq('Sufjan Stevens')
      expect(top_artist.weight).to eq(1)
      expect(top_artists.second.weight).to eq(2)
      expect(top_artist.songkick_id).to eq(118_509)
      expect(top_artist.on_tour?).to be_falsy
    end
  end

  it "gets a user's top spotify artists" do
    VCR.use_cassette('artist_top_spotify_artists') do
      user = create(
        :user,
        access_token: ENV['ACCESS_TOKEN'],
        refresh_token: ENV['REFRESH_TOKEN'],
        token_expiry: ENV['TOKEN_EXPIRY']
      )

      top_artists = Artist.top_spotify_artists(user, 'long_term')

      expect(top_artists.length).to eq(25)
      expect(top_artists.first.name).to eq('Sufjan Stevens')
      expect(top_artists.second.name).to eq('Weatherbox')
      expect(top_artists.first.weight).to eq(nil)
      expect(top_artists.first.songkick_id).to eq(nil)
      expect(top_artists.first.on_tour?).to be_falsy
    end
  end

  it "gets a user's unique recommended, weighted artists" do
    VCR.use_cassette('artist_recommended_artists') do
      user = create(
        :user,
        access_token: ENV['ACCESS_TOKEN'],
        refresh_token: ENV['REFRESH_TOKEN'],
        token_expiry: ENV['TOKEN_EXPIRY']
      )

      top_artists = Artist.top_spotify_artists(user, 'long_term')
      recommended = Artist.recommended(user, top_artists)
      top_artists_names = top_artists.map(&:name)
      duplicates = recommended.map do |artist|
        artist.name if top_artists_names.include?(artist.name)
      end.compact

      expect(recommended.length).to be > 24
      expect(duplicates.length).to eq(0)
      expect(recommended.first).to be_a(Artist)
      expect(recommended.first.name).to be_a(String)
      expect(recommended.first.weight).to eq(26)
      expect(recommended.last.weight).to eq(26)
      expect(recommended.uniq(&:name).length)
        .to eq(recommended.length)
    end
  end

  it "gets a user's top and recommended artists" do
    VCR.use_cassette('artist_all_top_and_recommended') do
      user = create(
        :user,
        access_token: ENV['ACCESS_TOKEN'],
        refresh_token: ENV['REFRESH_TOKEN'],
        token_expiry: ENV['TOKEN_EXPIRY']
      )

      all_artists = Artist.all(user, 'long_term')

      expect(all_artists.length).to be > 25
      expect(all_artists.first.weight).to eq(1)
      expect(all_artists.last.weight).to eq(26)
    end
  end
end
