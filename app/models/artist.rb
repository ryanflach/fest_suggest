class Artist
  attr_reader :weight,
              :songkick_id

  def initialize(params)
    @artist = params[:artist]
    @weight = params[:artist][:weight]
    @on_tour_until = params[:songkick][:on_tour_until]
    @songkick_id = params[:songkick][:id]
  end

  def self.all(current_user, range)
    top_artists = top_artists_complete(current_user, range)
    recommended_artists = recommended(current_user, top_artists)
    top_artists + recommended_artists
  end

  def self.spotify_service(current_user)
    Spotify::Service.new(current_user.access_token)
  end

  def self.songkick_service
    Songkick::Service.new
  end

  def self.top_spotify_artists(current_user, range)
    artists_data = spotify_service(current_user).top_25_artists(range)
    artists_data.map do |artist|
      Artist.new(artist: artist, songkick: {})
    end
  end

  def self.top_artists_complete(current_user, range)
    artists = artists_with_weight(current_user, range)
    compose_complete_artists_in_parallel(artists)
  end

  def self.recommended(current_user, top_artists)
    artists = RecommendationEngine.new(current_user, top_artists)
                                  .unique_recommended
    artists.map do |artist|
      artist[:weight] = 26
      Artist.new(artist: artist, songkick: {})
    end
  end

  def name
    artist[:name]
  end

  def on_tour?
    on_tour_until
  end

  def self.songkick_data(artist_name)
    songkick_service.artist_profile(artist_name)
  end

  def self.create_complete_artist(spotify_data, songkick_profile)
    Artist.new(
      artist: spotify_data,
      weight: spotify_data[:weight],
      songkick: {
        on_tour_until: songkick_profile[:onTourUntil],
        id: songkick_profile[:id]
      }
    )
  end

  def self.add_artist_weight(artists)
    artists.map.with_index(1) do |artist, weight|
      artist[:weight] = weight
    end
    artists
  end

  def self.artists_with_weight(current_user, range)
    add_artist_weight(
      spotify_service(current_user).top_25_artists(range)
    )
  end

  def self.compose_complete_artists_in_parallel(artists)
    artists.map do |artist|
      songkick_profile = songkick_data(artist[:name])
      create_complete_artist(artist, songkick_profile)
    end.sort_by!(&:weight)
  end

  def id
    artist[:id]
  end

  private

  attr_reader :artist,
              :on_tour_until
end
