class PlaylistEngine
  attr_reader :id

  RATE_LIMIT_BUFFER = 1.0

  def initialize(festival)
    @all_artists = artist_names(festival.festival)
    @service = Spotify::Service.new(User.site_admin.access_token)
    @id = create_playlist(festival.name)
    PlaylistWorker.perform_async(id, all_artists)
  end

  def self.artist_ids(service, artist_names)
    response = service.all_artist_ids(artist_names)
    if response[:all].nil?
      handle_rate_limiting(response)
      artist_ids(service, artist_names)
    else
      response[:all]
    end
  end

  def self.top_tracks(service, ids)
    response = service.each_artists_top_track(ids)
    if response[:all].nil?
      handle_rate_limiting(response)
      top_tracks(service, ids)
    else
      response[:all]
    end
  end

  def self.add_tracks(service, id, tracks)
    puts "Adding track(s): #{tracks} to playlist #{id}..."
    response = service.add_tracks_to_playlist(id, tracks)
    if response[:limit]
      handle_rate_limiting(response)
      add_tracks(service, id, tracks)
    else
      puts "Added #{tracks.length} track(s) to playlist #{id}."
    end
  end

  private

  attr_reader :service,
              :all_artists

  def create_playlist(festival_name)
    service.create_playlist(festival_name)
  end

  def artist_names(festival_data)
    festival_data[:performance].map do |artist|
      artist[:displayName]
    end
  end

  def self.handle_rate_limiting(response)
    sleep(response[:limit] + RATE_LIMIT_BUFFER)
  end
end
