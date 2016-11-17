module Songkick
  class Service < Base
    def initialize
      @base_url = 'https://api.songkick.com'
      @request_pool = Typhoeus::Hydra.hydra
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

      requests.reduce({}) do |end_hash, (artist, request)|
        result = parse(request.response.body)[:resultsPage][:results]
        end_hash[artist] = result[:artist] ? result[:artist].first : {}
        end_hash
      end
    end

    def upcoming_events(artist_ids)
      requests = artist_ids.map do |id|
        request = Typhoeus::Request.new(
          "#{base_url}/api/3.0/artists/#{id}/calendar.json",
          params: {
            apikey: ENV['SONGKICK_KEY'],
          }
        )
        request_pool.queue(request)
        request
      end

      request_pool.run

      requests.map do |request|
        parse(request.response.body)[:resultsPage][:results][:event]
      end
    end

    # --Planned functionality.--
    # def past_events(artist_ids)
    #   requests = artist_ids.map do |id|
    #     request = Typhoeus::Request.new(
    #       "#{base_url}/api/3.0/artists/#{id}/gigography.json",
    #       params: {
    #         apikey: ENV['SONGKICK_KEY'],
    #         min_date: "#{Date.today.year}-01-01"
    #       }
    #     )
    #     request_pool.queue(request)
    #     request
    #   end
    #
    #   request_pool.run
    #
    #   requests.map do |request|
    #     parse(request.response.body)[:resultsPage][:results][:event]
    #   end
    # end

    private

    attr_reader :base_url,
                :request_pool

  end
end
