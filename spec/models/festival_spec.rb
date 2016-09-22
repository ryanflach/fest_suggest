require 'rails_helper'
include SpotifyHelper

describe Festival do
  before(:all) { refresh_access_token if token_expired? }

  context 'with artists present' do
    it "returns the top 5 fests based on top and recommended artists" do
      VCR.use_cassette('festival_top_5_all') do
        user = create(:user)
        all_artists = Artist.all(user, 'long_term')
        top_5_fests = Festival.top_festivals(all_artists)

        expect(top_5_fests.length).to eq(5)
        expect(top_5_fests.first).to be_a(Festival)
        expect(top_5_fests.first.score).to be <= top_5_fests.second.score
        expect(top_5_fests.first.location).to eq('Austin, TX, US')
        expect(top_5_fests.first.other_artists_count).to be > 1
      end
    end
  end

  context 'with no artists present' do
    it 'returns the top 5 fests based on top and recommended artists' do
      top_5_fests = Festival.top_festivals([])

      expect(top_5_fests).to eq([])
    end
  end
end
