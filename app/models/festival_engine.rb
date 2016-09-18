class FestivalEngine
  def initialize(all_artists)
    @top_artists = top_artists_only(all_artists)
    @recommended_artists = recommended_artists_only(all_artists)
  end

  def unique_festivals
    @fests ||= festivals_only.uniq { |festival| festival[:displayName] }
  end

  def top_5_festivals
    unique_festivals.map do |festival|
      festival[:score] = score_festival(festival)
      festival[:top_artists] = filter_artists(festival, top_artists)
      festival[:rec_artists] =
        filter_artists(festival, recommended_artists)
      festival
    end.sort_by { |fest| fest[:score] }.take(5)
  end

  private

  attr_reader :top_artists,
              :recommended_artists

  def on_tour_artists
    top_artists.map { |artist| artist if artist.on_tour? }.compact
  end

  def num_top_artists_with_festivals
    artists = []
    top_artist_names = artist_names(on_tour_artists)
    unique_festivals.each do |festival|
      fest_bands = festival_band_names(festival)
      top_artist_names.each do |artist|
        artists << artist if fest_bands.include?(artist)
      end
    end
    artists.uniq.length
  end

  def artist_names(artists)
    artists.map(&:name)
  end

  def all_upcoming_events
    on_tour_artists.map do |artist|
      Songkick::Service.new.upcoming_events(artist.songkick_id)
    end
  end

  def festivals_only
    festivals = []
    all_upcoming_events.each do |artists_events|
      artists_events.each do |event|
        if event[:type] == 'Festival' && event[:performance].length > 4
          festivals << event
        end
      end
    end
    festivals
  end

  def top_artists_only(all_artists)
    all_artists.map do |artist|
      artist if artist.weight < 26
    end.compact
  end

  def recommended_artists_only(all_artists)
    all_artists.map do |artist|
      artist if artist.weight == 26
    end.compact
  end

  def score_festival(fest)
    max_top_artists_at_fest = num_top_artists_with_festivals
    top_artists_at_fest = filter_artists(fest, top_artists)
    rec_artists_at_fest = filter_artists(fest, recommended_artists)
    if max_top_artists_at_fest == top_artists_at_fest.length
      -rec_artists_at_fest.length
    else
      score_artists(top_artists_at_fest) /
        top_artists_at_fest.length -
        rec_artists_at_fest.length -
        (top_artists_at_fest.length * 2)
    end
  end

  def filter_artists(festival, artists)
    artists.map do |artist|
      artist if festival_band_names(festival).include?(artist.name)
    end.compact
  end

  def festival_band_names(festival)
    festival[:performance].map do |booking|
      booking[:artist][:displayName]
    end
  end

  def score_artists(artists)
    artists.reduce(0) { |value, artist| value += artist.weight }
  end
end
