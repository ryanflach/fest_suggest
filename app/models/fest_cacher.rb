class FestCacher
  def initialize(user, range)
    @user = user
    @range = range
  end

  def process_cache
    label = "#{user.id}-top-fests-#{range}"
    Rails.cache.fetch(label, expires_in: 1.hour) do
      artists = Artist.all(user, range)
      Festival.top_festivals(artists)
    end
  end

  private

  attr_reader :user,
              :range
end
