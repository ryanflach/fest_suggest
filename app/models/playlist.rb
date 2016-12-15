class Playlist < ApplicationRecord
  validates :name, presence: true
  validates :spotify_id, presence: true, uniqueness: true

  def self.find_or_create(festival)
    find_or_create_by(name: festival.name) do |playlist|
      playlist.spotify_id = PlaylistEngine.new(festival).id
    end
  end

  def is_followed?(user)
    Spotify::Service.new(user.access_token)
                    .user_following_playlist?(
                      user.username,
                      spotify_id
                    )
  end

  def process_follow(user, current_status)
    service = Spotify::Service.new(user.access_token)
    if current_status == 'Unfollow'
      service.unfollow_playlist(spotify_id)
    else
      service.follow_playlist(spotify_id)
    end
  end
end
