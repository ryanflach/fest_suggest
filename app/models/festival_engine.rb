class FestivalEngine
  def initialize(all_artists)
    @top_artists = top_artists_only(all_artists)
    @recommended_artists = recommended_artists_only(all_artists)
  end

  def unique_festivals
    festivals_only.uniq { |festival| festival[:displayName] }
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

  def artist_names(artists)
    artists.map(&:name)
  end

  def all_upcoming_events
    threads = []
    events = []
    events_mutex = Mutex.new
    connection = Songkick::Service.new
    on_tour_artists.each do |artist|
      threads << Thread.new(artist, events) do |artist, events|
        artists_events = connection.upcoming_events(artist.songkick_id)
        events_mutex.synchronize { events << artists_events }
      end
    end
    threads.each(&:join)
    events
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
    num_bands = fest[:performance].length
    top_artists_at_fest = filter_artists(fest, top_artists)
    rec_artists_at_fest = filter_artists(fest, recommended_artists)
    top_artist_bonus = (top_artists_at_fest.length / num_bands) * 2
    rec_artist_bonus = (rec_artists_at_fest.length / num_bands) / 2
    top_artists_score = score_artists(top_artists_at_fest)
    rec_artists_score = score_artists(rec_artists_at_fest)
    top_artists_score + rec_artists_score - top_artist_bonus -
      rec_artist_bonus
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
