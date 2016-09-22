class Artist
  attr_reader :weight,
              :songkick_id

  def initialize(params)
    @artist = params[:artist]
    @weight = params[:artist][:weight]
    @on_tour_until = params[:songkick][:on_tour_until]
    @songkick_id = params[:songkick][:id]
    @songkick_name = params[:songkick][:name]
  end

  def self.spotify_service(current_user)
    Spotify::Service.new(current_user.access_token)
  end

  def self.all(current_user, range)
    engine = ArtistEngine.new(current_user, range)
    top_artists = engine.complete_top_artists
    return [] if top_artists.empty?
    recommended_artists = engine.recommended(top_artists)
    top_artists + recommended_artists
  end

  def self.top_spotify_artists(current_user, range)
    artists_data = spotify_service(current_user).top_25_artists(range)
    artists_data.map do |artist|
      Artist.new(artist: artist, songkick: {})
    end
  end

  def self.top_artists_complete(current_user, range)
    engine = ArtistEngine.new(current_user, range)
    artists = engine.complete_top_artists
  end

  def id
    artist[:id]
  end

  def name
    songkick_name || artist[:name]
  end

  def on_tour?
    on_tour_until
  end

  private
  attr_reader :artist,
              :on_tour_until,
              :songkick_name
end
