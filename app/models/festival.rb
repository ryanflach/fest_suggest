class Festival
  attr_reader :score,
              :top_artists,
              :rec_artists,
              :festival

  def initialize(params, data=nil)
    @festival = params
    @score = data[:score]
    @top_artists = data[:top_artists]
    @rec_artists = data[:rec_artists]
  end

  def self.top_festivals(all_artists)
    return [] if all_artists.empty?
    festivals = FestivalEngine.new(all_artists).top_5_festivals
    festivals.map do |festival|
      Rails.cache.fetch(festival[:displayName], expires_in: 1.hour) do
        Festival.new(
          festival,
          {
            score: festival[:score],
            top_artists: festival[:top_artists],
            rec_artists: festival[:rec_artists]
          }
        )
      end
    end
  end

  def name
    festival[:displayName]
  end

  def start_date
    festival[:start][:date].split('-')[1..2].join('/')
  end

  def end_date
    festival[:end][:date].split('-')[1..2].join('/')
  end

  def url
    festival[:uri]
  end

  def location
    festival[:location][:city]
  end

  def other_artists_count
    festival[:performance].length -
      (top_artists.length + rec_artists.length)
  end
end
