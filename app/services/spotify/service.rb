class Spotify::Service < Base
  def initialize(token)
    @base_url = 'https://api.spotify.com'
    @headers  = { 'Authorization': "Bearer #{token}" }
    @request_pool = Typhoeus::Hydra.hydra
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

  def create_playlist(name)
    request = Typhoeus::Request.new(
      "#{base_url}/v1/users/#{ENV['FS_ADMIN_NAME']}/playlists",
      method: :post,
      headers: {
        'Authorization': headers[:Authorization],
        'Content-Type': 'application/json'
      },
      body: { name: name }.to_json
    ).run
    parse(request.response_body)[:id]
  end

  def each_artists_top_track(artist_ids)
    requests = artist_ids.map do |id|
      request = Typhoeus::Request.new(
        "#{base_url}/v1/artists/#{id}/top-tracks",
        headers: headers,
        params: { country: 'US' }
      )
      request_pool.queue(request)
      request
    end

    request_pool.run

    requests.reduce([]) do |uris, request|
      parsed = parse(request.response.body)[:tracks]
      parsed.empty? ? uris : uris << parsed.first[:uri]
    end
  end

  def add_tracks_to_playlist(playlist_id, tracks)
    request = Typhoeus::Request.new(
      "#{base_url}/v1/users/#{ENV['FS_ADMIN_NAME']}" \
      "/playlists/#{playlist_id}/tracks",
      method: :post,
      headers: {
        'Authorization': headers[:Authorization],
        'Content-Type': 'application/json'
      },
      body: { uris: tracks }.to_json
    ).run
    parse(request.response_body)
  end

  def all_artist_ids(artist_names)
    requests = artist_names.map do |name|
      request = Typhoeus::Request.new(
        "#{base_url}/v1/search?type=artist",
        headers: headers,
        params: {
          q: name.gsub(' ', '+'),
          type: 'artist',
          limit: 1
        }
      )
      request_pool.queue(request)
      request
    end

    request_pool.run

    requests.reduce([]) do |ids, request|
      parsed = parse(request.response.body)[:artists][:items]
      parsed.empty? ? ids : ids << parsed.first[:id]
    end
  end

  private

  attr_reader :base_url,
              :headers,
              :request_pool

  def request_user_data
    request = Typhoeus::Request.new(
      "#{base_url}/v1/me",
      headers: headers
    ).run
    parse(request.response_body)
  end
end
