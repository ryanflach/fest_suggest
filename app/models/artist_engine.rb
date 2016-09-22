class ArtistEngine
  def initialize(user, range)
    @user = user
    @range = range
  end

  def complete_top_artists
    artists = artists_with_weight
    compose_complete_artists(artists)
  end

  def recommended(top_artists)
    artists = ArtistRecommendationEngine.new(user, top_artists)
                                        .unique_recommended
    artists.map do |artist|
      artist[:weight] = 26
      Artist.new(artist: artist, songkick: {})
    end
  end

  private
  attr_reader :user,
              :range

  def artists_with_weight
    add_weight_to_artists(
      Spotify::Service.new(user.access_token).top_25_artists(range)
    )
  end

  def add_weight_to_artists(artists)
    artists.map.with_index(1) do |artist, weight|
      artist[:weight] = weight
    end
    artists
  end

  def create_complete_artist(spotify_data, songkick_profile)
    Artist.new(
      artist: spotify_data,
      weight: spotify_data[:weight],
      songkick: {
        on_tour_until: songkick_profile[:onTourUntil],
        id: songkick_profile[:id],
        name: songkick_profile[:displayName]
      }
    )
  end

  def compose_complete_artists(artists)
    artists.map do |artist|
      songkick_profile = songkick_data(artist[:name])
      create_complete_artist(artist, songkick_profile)
    end.sort_by!(&:weight)
  end

  def songkick_data(artist_name)
    Songkick::Service.new.artist_profile(artist_name)
  end

end
