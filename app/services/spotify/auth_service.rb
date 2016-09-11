class Spotify::AuthService < Spotify::Base
  attr_reader :code,
              :connection

  def initialize(code = nil)
    @code = code
    @connection = initialize_connection
    setup_basic_auth
  end

  def process_auth
    tokens = retrieve_user_tokens
    format_token_response(tokens)
  end

  def refresh_user_tokens(refresh_token)
    response = connection.post do |request|
      request.body = {
        'grant_type'    => 'refresh_token',
        'refresh_token' => refresh_token
      }
    end
    format_token_response(parse(response))
  end

  private

  def initialize_connection
    Faraday.new('https://accounts.spotify.com/api/token') do |build|
      build.request :url_encoded
      build.adapter :net_http
    end
  end

  def setup_basic_auth
    connection.basic_auth(ENV['SPOTIFY_CLIENT'], ENV['SPOTIFY_SECRET'])
  end

  def retrieve_user_tokens
    response = connection.post do |request|
      request.body = {
        'grant_type'   => 'authorization_code',
        'code'         => code,
        'redirect_uri' => ENV['SPOTIFY_REDIRECT']
      }
    end
    parse(response)
  end

  def format_token_response(tokens)
    refresh_token = tokens[:refresh_token]
    hash = {
      access_token:  tokens[:access_token],
      token_expiry:  Time.now + tokens[:expires_in]
    }
    hash[:refresh_token] = refresh_token if refresh_token
    hash
  end
end
