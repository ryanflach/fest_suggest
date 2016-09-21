class FestCacher
  def initialize(user, range)
    @user = user
    @range = range
  end

  def process_cache
    label = "#{user.id}-top-fests-#{range}"
    read_cache(label) ? read_cache(label) : write_return_cache(label)
  end

  private

  attr_reader :user,
              :range

  def write_return_cache(label)
    artists = Artist.all(user, range)
    Rails.cache.write(
      label,
      Festival.top_festivals(artists),
      expires_in: 1.hour
    )
    read_cache(label)
  end

  def read_cache(label)
    Rails.cache.read(label)
  end
end
