require 'rails_helper'
include SpotifyHelper

describe Festival do
  before(:all) { refresh_access_token if token_expired? }

  it "returns all unique festivals for given artists" do
    VCR.use_cassette('festival_all') do
      user = create(:user)
      top_artists = Artist.top_artists_complete(user, 'long_term')
      festivals = Festival.all(top_artists)

      expect(festivals.first).to be_a(Festival)
      expect(festivals.length).to eq(19)
      expect(festivals.first.name)
        .to eq('Dayton Music, Art & Film Festival 2016')
      expect(festivals.first.start_date)
        .to be <= festivals.second.start_date
    end
  end

  it "returns the top 5 fests based on top and recommended artists" do
    VCR.use_cassette('festival_top_5') do
      user = create(:user)
      all_artists = Artist.all(user, 'long_term')
      top_5_fests = Festival.top_festivals(all_artists)

      expect(top_5_fests.length).to eq(5)
      expect(top_5_fests.first).to be_a(Festival)
      expect(top_5_fests.first.score).to be <= top_5_fests.second.score
    end
  end
end
