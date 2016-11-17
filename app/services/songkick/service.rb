module Songkick
  class Service < Base
    def initialize
      @base_url = 'https://api.songkick.com'
      @request_pool = Typhoeus::Hydra.hydra
      @connection = initialize_connection
    end

    def artist_profiles(artist_names)
      requests = artist_names.map do |artist|
        request = Typhoeus::Request.new(
          "#{base_url}/api/3.0/search/artists.json",
          params: {
            apikey: ENV['SONGKICK_KEY'],
            query: artist
          }
        )
        request_pool.queue(request)
        [artist, request]
      end

      request_pool.run

      results = requests.reduce({}) do |end_hash, (artist, request)|
        result = parse(request.response.body)[:resultsPage][:results]
        end_hash[artist] = result[:artist] ? result[:artist].first : {}
        end_hash
      end
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

    attr_reader :connection,
                :base_url,
                :request_pool

    def initialize_connection
      Faraday.new('https://api.songkick.com') do |build|
        build.params[:apikey] = ENV['SONGKICK_KEY']
        build.adapter :net_http
      end
    end
  end
end
