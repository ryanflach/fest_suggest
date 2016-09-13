class Songkick::Service < Base
  def initialize
    @connection = initialize_connection
  end

  def artist_profile(artist_name)
    response = connection.get('/api/3.0/search/artists.json') do |req|
      req.params[:query] = artist_name
    end
    parse(response.body)[:resultsPage][:results][:artist].first
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
