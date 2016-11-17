require 'rails_helper'

RSpec.describe 'Songkick service' do
  context '#artist_profiles' do
    it "returns basic profiles for a collection of artists" do
      VCR.use_cassette('songkick_service_artist_profile') do
        artists = ['Sufjan Stevens', 'Bon Iver']
        artist_profiles = Songkick::Service.new.artist_profiles(artists)

        expect(artist_profiles[artists.first][:id]).to eq(118_509)
        expect(artist_profiles[artists.last][:id]).to eq(590_705)
      end
    end

    it "returns an name and empty hash if no artist found" do
      VCR.use_cassette('songkick_service_artist_not_found') do
        artist = ['asdfasdfsdfasdf']
        artist_profile = Songkick::Service.new.artist_profiles(artist)

        expect(artist_profile[artist.first]).to eq({})
        expect(artist_profile[artist.first][:id]).to eq(nil)
      end
    end
  end

  context '#upcoming_events' do
    it "returns artists' upcoming events by artist id" do
      VCR.use_cassette('songkick_service_upcoming_events') do
        artist_ids = [403_540_6, 590_705]
        upcoming_events = Songkick::Service.new
                                           .upcoming_events(artist_ids)

        expect(upcoming_events.first.last[:type]).to eq('Concert')
        expect(upcoming_events.first.last[:displayName])
          .to eq(
            'Kishi Bashi with Lee Fields & The Expressions, ' \
            'City of the Sun, Ezra Furman, and 35 more… at ' \
            'Savannah Sinfonietta & Chamber Players Historic ' \
            'District Packages (March 9, 2017)'
          )
      end
    end
  end

  # Skipped due to being solely planned functionality - method arguments
  # will need to be adjusted (take a collection rather than a single id)
  # due to the use of Typhoeus.
  context '#past_events' do
    xit "returns an artist's past events from start of year by id" do
      VCR.use_cassette('songkick_service_past_events') do
        artist_id = 118_509
        past_events = Songkick::Service.new.past_events(artist_id)

        expect(past_events.first[:type]).to eq('Concert')
        expect(past_events.first[:displayName])
          .to eq('Sufjan Stevens at State Theatre (February 23, 2016)')
      end
    end
  end
end
