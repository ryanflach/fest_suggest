class ArtistRecommendationEngine
  def initialize(user, top_artists)
    @user = user
    @top_artists = top_artists
  end

  def unique_recommended
    recommended_artists.map do |track|
      unless top_artists_names.include?(track[:artists].first[:name])
        track[:artists].first
      end
    end.compact
  end

  private

  attr_reader :user,
              :top_artists

  def top_5_artists_ids
    top_artists[0..4].map(&:id).join(',')
  end

  def top_artists_names
    top_artists.map(&:name)
  end

  def recommended_artists
    Spotify::Service.new(user.access_token)
                    .recommended_artists(top_5_artists_ids)
                    .uniq { |track| track[:artists].first[:name] }
  end
end
