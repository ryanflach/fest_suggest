require 'rails_helper'

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
        expect(second_artist[:name]).to eq('Everything Everything')
      end
    end

    it "gets a user's top 25 artists for the last 4 weeks" do
      VCR.use_cassette('spotify_service_top_artists_short_term') do
        top_25 = Spotify::Service.new(ENV['ACCESS_TOKEN'])
                                 .top_25_artists('short_term')
        top_artist = top_25.first
        second_artist = top_25.second

        expect(top_25.length).to eq(9)
        expect(top_artist[:name]).to eq('Wye Oak')
        expect(second_artist[:name]).to eq('DJ Shadow')
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

        expect(recommended.length).to eq(50)
        expect(recommended.first[:artists].first[:name]).to eq('Warpaint')
      end
    end
  end
end

def token_expired?
  ENV['TOKEN_EXPIRY'] < Time.now
end

def refresh_access_token
  new_tokens = Spotify::AuthService.new
                                   .refresh_user_tokens(
                                     ENV['REFRESH_TOKEN']
                                   )
  update_yml_file(new_tokens)
end

def update_yml_file(tokens)
  data = YAML.load_file('config/application.yml')
  data['test']['ACCESS_TOKEN'] = tokens[:access_token]
  data['test']['TOKEN_EXPIRY'] = tokens[:token_expiry]
  data['test']['REFRESH_TOKEN'] =
    tokens[:refresh_token] if tokens[:refresh_token]
  File.open('config/application.yml', 'w') do |file|
    YAML.dump(data, file)
  end
end
