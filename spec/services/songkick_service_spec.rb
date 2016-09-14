require 'rails_helper'

RSpec.describe 'Songkick service' do
  context '#artist_profile' do
    it "returns an artist's basic profile" do
      VCR.use_cassette('songkick_service_artist_profile') do
        artist = 'Sufjan Stevens'
        artist_profile = Songkick::Service.new.artist_profile(artist)

        expect(artist_profile[:id]).to eq(118_509)
      end
    end
  end

  context '#upcoming_events' do
    it "returns an artist's upcoming events by artist id" do
      VCR.use_cassette('songkick_service_upcoming_events') do
        artist_id = 403_540_6
        upcoming_events = Songkick::Service.new
                                           .upcoming_events(artist_id)

        expect(upcoming_events.last[:type]).to eq('Concert')
        expect(upcoming_events.last[:displayName])
          .to eq(
            'Kishi Bashi with Laura Gibson at' \
            ' Variety Playhouse (November 2, 2016)'
          )
      end
    end
  end

  context '#past_events' do
    it "returns an artist's past events from start of year by id" do
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
