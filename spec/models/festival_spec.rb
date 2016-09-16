require 'rails_helper'
include SpotifyHelper

describe Festival do
  before(:all) { refresh_access_token if token_expired? }

  it "returns all unique festivals for given artists" do
    VCR.use_cassette('festival_all') do
      user = create(
        :user,
        access_token: ENV['ACCESS_TOKEN'],
        refresh_token: ENV['REFRESH_TOKEN'],
        token_expiry: ENV['TOKEN_EXPIRY']
      )

      top_artists = Artist.top_artists_complete(user, 'long_term')
      festivals = Festival.all(top_artists)

      expect(festivals.first).to be_a(Festival)
      expect(festivals.length).to eq(19)
      expect(festivals.first.name)
        .to eq('Dayton Music, Art & Film Festival 2016')
      expect(festivals.first.start_date)
        .to be < festivals.last.start_date
    end
  end
end
