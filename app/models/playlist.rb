class Playlist < ApplicationRecord
  validates :name, presence: true
  validates :spotify_id, presence: true, uniqueness: true
end
