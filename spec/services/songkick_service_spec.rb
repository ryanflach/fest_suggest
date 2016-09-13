require 'rails_helper'

RSpec.describe 'Songkick service' do
  context '#artist_profile' do
    it "returns an artists basic profile" do
      VCR.use_cassette('songkick_service_artist_profile') do
        artist = 'Sufjan Stevens'
        artist_profile = Songkick::Service.new.artist_profile(artist)

        expect(artist_profile[:id]).to eq(118_509)
      end
    end
  end
end
