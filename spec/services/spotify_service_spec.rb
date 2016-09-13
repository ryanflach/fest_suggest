require 'rails_helper'

RSpec.describe 'Spotify service' do
  context '#top_artists' do
    it "gets a user's top 25 artists" do
      VCR.use_cassette('spotify_service_top_artists') do
        refresh_access_token

        
      end
    end
  end
end

def refresh_access_token
  if ENV['TOKEN_EXPIRY'] < Time.now
    new_tokens = Spotify::AuthService.new
                                     .refresh_user_tokens(
                                       ENV['REFRESH_TOKEN']
                                     )
    update_yml_file(new_tokens)
  end
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
