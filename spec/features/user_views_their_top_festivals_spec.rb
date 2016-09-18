require 'rails_helper'
include SpotifyHelper

RSpec.describe 'User views their top festivals' do
  before(:all) { refresh_access_token if token_expired? }

  context 'logged-in user for all time top artists' do
    scenario 'they visit the root path' do
      VCR.use_cassette('festival_top_5_all') do
        user = create(:user)

        allow_any_instance_of(ApplicationController)
          .to receive(:current_user)
          .and_return(user)

        visit '/'
        click_on 'top 5 by all time top artists'

        within('table thead') do
          expect(page).to have_content('Rank')
          expect(page).to have_content('Festival Name')
          expect(page).to have_content('Location')
          expect(page).to have_content('Top Artists')
          expect(page).to have_content('Recommended Artists')
          expect(page).to have_content('Other Artists')
        end

        within("#fest-1") do
          expect(page)
            .to have_link('Austin City Limits Music Festival 2016')
          expect(page).to have_content('Local Natives')
          expect(page).to have_content('Band of Horses')
          expect(page).to have_content('99+')
        end

        expect(page).to_not have_css("#fest-6")
      end
    end
  end

  context 'logged-in user for 6 month top artists' do
    scenario 'they visit the root path' do
      VCR.use_cassette('festival_top_5_6_months') do
        user = create(:user)

        allow_any_instance_of(ApplicationController)
          .to receive(:current_user)
          .and_return(user)

        visit '/'
        click_on 'top 5 by artists last 6 months'

        within('table thead') do
          expect(page).to have_content('Rank')
          expect(page).to have_content('Festival Name')
          expect(page).to have_content('Location')
          expect(page).to have_content('Top Artists')
          expect(page).to have_content('Recommended Artists')
          expect(page).to have_content('Other Artists')
        end

        within("#fest-1") do
          expect(page)
            .to have_link('Austin City Limits Music Festival 2016')
          expect(page).to have_content('Kygo')
          expect(page).to have_content('N/A')
          expect(page).to have_content('97+')
        end

        expect(page).to_not have_css("#fest-6")
      end
    end
  end

  context 'logged-in user for 4 week top artists' do
    scenario 'they visit the root path' do
      VCR.use_cassette('festival_top_5_4_weeks') do
        user = create(:user)

        allow_any_instance_of(ApplicationController)
          .to receive(:current_user)
          .and_return(user)

        visit '/'
        click_on 'top 5 by artists last 4 weeks'

        within('table thead') do
          expect(page).to have_content('Rank')
          expect(page).to have_content('Festival Name')
          expect(page).to have_content('Location')
          expect(page).to have_content('Top Artists')
          expect(page).to have_content('Recommended Artists')
          expect(page).to have_content('Other Artists')
        end

        within("#fest-1") do
          expect(page)
            .to have_link('Austin City Limits Music Festival 2016')
          expect(page).to have_content('Young the Giant')
          expect(page).to have_content('The Front Bottoms')
          expect(page).to have_content('97+')
        end

        expect(page).to_not have_css("#fest-6")
      end
    end
  end
end
