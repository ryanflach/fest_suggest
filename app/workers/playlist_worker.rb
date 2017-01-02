class PlaylistWorker
  include Sidekiq::Worker
  sidekiq_options concurrency: 1

  MAX = 25

  def perform(playlist_id, artist_names)
    service = Spotify::Service.new(User.site_admin.access_token)

    until artist_names.empty?
      ids = PlaylistEngine.artist_ids(service, artist_names.shift(MAX))
      tracks = PlaylistEngine.top_tracks(service, ids)
      PlaylistEngine.add_tracks(service, playlist_id, tracks)
    end
  end
end
