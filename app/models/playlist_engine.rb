class PlaylistEngine
  attr_reader :id

  PLAYLIST_MAX = 100

  def initialize(festival)
    @all_artists = artist_names(festival.festival)
    @service = Spotify::Service.new(User.site_admin.access_token)
    @id = create_playlist(festival.name)
    PlaylistWorker.perform_async(id, all_artists)
  end

  private

  attr_reader :service,
              :all_artists

  def create_playlist(festival_name)
    service.create_playlist(festival_name)
  end

  def artist_names(festival_data)
    festival_data[:performance].first(PLAYLIST_MAX).map do |artist|
      artist[:displayName]
    end
  end
end
