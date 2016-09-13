class Spotify::Service < Base
  def initialize(token)
    @token = token
    @connection = initialize_connection
  end

  def recommended_artists(top_5_artist_ids)
    response = connection.get('/v1/recommendations') do |request|
      request.params[:seed_artists] = top_5_artist_ids
      request.params[:limit] = 50
    end
    parse(response.body)[:tracks]
  end

  def top_25_artists(time_range)
    response = connection.get('/v1/me/top/artists') do |request|
      request.params[:limit] = 25
      request.params[:time_range] = time_range
    end
    parse(response.body)[:items]
  end

  def get_username
    data = request_user_data
    data[:display_name].nil? ? data[:id] : data[:display_name]
  end

  private

  attr_reader :token,
              :connection

  def initialize_connection
    Faraday.new('https://api.spotify.com') do |build|
      build.adapter :net_http
      build.headers['Authorization'] = "Bearer #{token}"
    end
  end

  def request_user_data
    response = connection.get('/v1/me')
    parse(response.body)
  end
end
