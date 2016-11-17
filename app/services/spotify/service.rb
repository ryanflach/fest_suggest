class Spotify::Service < Base
  def initialize(token)
    @base_url = 'https://api.spotify.com'
    @headers  = { 'Authorization': "Bearer #{token}" }
  end

  def recommended_artists(top_5_artist_ids)
    request = Typhoeus::Request.new(
      "#{base_url}/v1/recommendations",
      headers: headers,
      params: {
        seed_artists: top_5_artist_ids,
        limit: 100
      }
    ).run
    parse(request.response_body)[:tracks]
  end

  def top_25_artists(time_range)
    request = Typhoeus::Request.new(
      "#{base_url}/v1/me/top/artists",
      headers: headers,
      params: {
        limit: 25,
        time_range: time_range
      }
    ).run
    parse(request.response_body)[:items]
  end

  def get_username
    data = request_user_data
    data[:display_name].nil? ? data[:id] : data[:display_name]
  end

  private

  attr_reader :base_url,
              :headers

  def request_user_data
    request = Typhoeus::Request.new(
      "#{base_url}/v1/me",
      headers: headers
    ).run
    parse(request.response_body)
  end
end
