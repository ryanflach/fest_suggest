class FestivalEngine
  def initialize(artists)
    @artists = artists
  end

  def unique_festivals
    festivals_only.uniq { |festival| festival[:displayName] }
  end

  private

  attr_reader :artists

  def on_tour_artists
    artists.map { |artist| artist if artist.on_tour? }.compact
  end

  def artist_names
    on_tour_artists.map(&:name)
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
end
