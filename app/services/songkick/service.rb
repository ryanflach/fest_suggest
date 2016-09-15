module Songkick
  class Service < Base
    def initialize
      @connection = initialize_connection
    end

    def artist_profile(artist_name)
      response = connection.get('/api/3.0/search/artists.json') do |req|
        req.params[:query] = artist_name
      end
      parse(response.body)[:resultsPage][:results][:artist].first
    end

    def upcoming_events(artist_id)
      response = connection.get(
        "/api/3.0/artists/#{artist_id}/calendar.json"
      )
      parse(response.body)[:resultsPage][:results][:event]
    end

    def past_events(artist_id)
      response = connection.get(
        "/api/3.0/artists/#{artist_id}/gigography.json"
      ) do |req|
        req.params[:min_date] = "#{Date.today.year}-01-01"
      end
      parse(response.body)[:resultsPage][:results][:event]
    end

    private

    attr_reader :connection

    def initialize_connection
      Faraday.new('https://api.songkick.com') do |build|
        build.params[:apikey] = ENV['SONGKICK_KEY']
        build.adapter :net_http
      end
    end
  end
end
