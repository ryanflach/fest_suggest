require 'rails_helper'
include SpotifyHelper

RSpec.describe 'User views their top festivals' do
  before(:all) { refresh_access_tokens if token_expired? }

  context 'logged-in user for all time top artists' do
    scenario 'they visit the root path', js: true do
      VCR.use_cassette('festival_top_5_all') do
        user = create(:user)

        allow_any_instance_of(ApplicationController)
          .to receive(:current_user)
          .and_return(user)

        visit '/'
        click_on 'Top 5 Fests by All Time Top Artists'

        # Wait for requests
        sleep(8)

        within('table thead') do
          expect(page).to have_content('Rank')
          expect(page).to have_content('Festival Name')
          expect(page).to have_content('Location')
          expect(page).to have_content('Dates')
          expect(page).to have_content('Top Artists')
          expect(page).to have_content('Recommended Artists')
          expect(page).to have_content('Other Artists')
        end

        within("#fest-01") do
          expect(page)
            .to have_link("Primavera Sound Festival 2017")
          expect(page).to have_content('Local Natives')
          expect(page).to have_content('Tycho')
          expect(page).to have_content('Bon Iver')
          expect(page).to have_content('Angel Olsen')
          expect(page).to have_content('169+')
        end

        expect(page).to_not have_css("#fest-06")
      end
    end
  end

  context 'logged-in user for 6 month top artists' do
    scenario 'they visit the root path', js: true do
      VCR.use_cassette('festival_top_5_6_months') do
        user = create(:user)

        allow_any_instance_of(ApplicationController)
          .to receive(:current_user)
          .and_return(user)

        visit '/'
        click_on "Top 5 Fests by Last 6 Month's Top Artists"

        # Wait for requests
        sleep(8)

        within('table thead') do
          expect(page).to have_content('Rank')
          expect(page).to have_content('Festival Name')
          expect(page).to have_content('Location')
          expect(page).to have_content('Top Artists')
          expect(page).to have_content('Recommended Artists')
          expect(page).to have_content('Other Artists')
        end

        within("#fest-01") do
          expect(page)
            .to have_link("Primavera Sound Festival 2017")
          expect(page).to have_content('Local Natives')
          expect(page).to have_content('Bon Iver')
          expect(page).to have_content('Tycho')
          expect(page).to have_content('Frank Ocean')
          expect(page).to have_content('Mitski')
          expect(page).to have_content('Kevin Morby')
          expect(page).to have_content('Angel Olsen')
          expect(page).to have_content('166+')
        end

        expect(page).to_not have_css("#fest-06")
      end
    end
  end

  context 'logged-in user for 4 week top artists' do
    scenario 'they visit the root path', js: true do
      VCR.use_cassette('festival_top_5_4_weeks') do
        user = create(:user)

        allow_any_instance_of(ApplicationController)
          .to receive(:current_user)
          .and_return(user)

        visit '/'
        click_on "Top 5 Fests by Last 4 Week's Top Artists"

        # Wait for requests
        sleep(8)

        within('table thead') do
          expect(page).to have_content('Rank')
          expect(page).to have_content('Festival Name')
          expect(page).to have_content('Location')
          expect(page).to have_content('Top Artists')
          expect(page).to have_content('Recommended Artists')
          expect(page).to have_content('Other Artists')
        end

        within("#fest-01") do
          expect(page)
            .to have_link('Primavera Sound Festival 2017')
          expect(page).to have_content('Bon Iver')
          expect(page).to have_content('BadBadNotGood')
          expect(page).to have_content('Run The Jewels')
          expect(page).to have_content('Mitski')
          expect(page).to have_content('Local Natives')
          expect(page).to have_content('Angel Olsen')
          expect(page).to have_content('Weyes Blood')
          expect(page).to have_content('166+')
        end

        expect(page).to_not have_css("#fest-06")
      end
    end
  end

  context 'logged-in user no top artists with festivals' do
    scenario 'they visit the root path', js: true do
      VCR.use_cassette('festival_top_5_none') do
        user = create(:user)

        allow_any_instance_of(ApplicationController)
          .to receive(:current_user)
          .and_return(user)

        allow_any_instance_of(FestivalEngine)
          .to receive(:on_tour_artists)
          .and_return([])

        visit '/'
        click_on 'Top 5 Fests by All Time Top Artists'

        # Wait for requests
        sleep(3)

        expect(page).to have_link("Songkick")
        expect(page).to_not have_css("#fest-01")
      end
    end
  end
end
