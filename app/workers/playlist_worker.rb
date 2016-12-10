class PlaylistWorker
  include Sidekiq::Worker

  def perform(playlist_id, artist_names)
    service = Spotify::Service.new(User.site_admin.access_token)
    artist_ids = []
    top_tracks = []

    until artist_names.empty?
      ids = service.all_artist_ids(artist_names.shift(25))
      artist_ids.concat(ids)
      sleep(15)
    end

    until artist_ids.empty?
      tracks = service.each_artists_top_track(artist_ids.shift(25))
      top_tracks.concat(tracks)
      sleep(15)
    end

    service.add_tracks_to_playlist(playlist_id, top_tracks)
    puts "Added tracks to playlist #{playlist_id}"
  end
end
