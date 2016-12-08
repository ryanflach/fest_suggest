class Playlist < ApplicationRecord
  validates :name, presence: true
  validates :spotify_id, presence: true, uniqueness: true

  def self.find_or_create(festival_data)
    festival_name = festival_data[:displayName]
    find_or_create_by(name: festival_name) do |playlist|
      playlist.spotify_id = PlaylistEngine.new(festival_data).id
    end
  end
end
