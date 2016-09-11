class Spotify::UserService < Spotify::Base
  attr_reader :token,
              :connection

  def initialize(token)
    @token = token
    @connection = initialize_connection
  end

  def get_username
    data = request_user_data
    data[:display_name].nil? ? data[:id] : data[:display_name]
  end

  private

  def initialize_connection
    Faraday.new('https://api.spotify.com/v1/me') do |build|
      build.adapter :net_http
      build.headers['Authorization'] = "Bearer #{token}"
    end
  end

  def request_user_data
    response = connection.get
    parse(response)
  end
end
