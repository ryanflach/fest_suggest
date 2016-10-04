class Cacher
  def initialize(user, range)
    @user = user
    @range = range
  end

  def process_festival_cache
    label = "#{user.id}-top-fests-#{range}"
    Rails.cache.fetch(label, expires_in: 1.hour) do
      artists = Artist.all(user, range)
      Festival.top_festivals(artists)
    end
  end

  def process_artist_cache
    label = "#{user.id}-top-artists-#{range}"
    Rails.cache.fetch(label, expires_in: 1.hour) do
      Artist.top_spotify_artists(user, range)
    end
  end

  private

  attr_reader :user,
              :range
end
