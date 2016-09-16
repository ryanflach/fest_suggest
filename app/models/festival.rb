class Festival
  attr_reader :score,
              :top_artists,
              :rec_artists

  def initialize(params, score = nil, top_artists = nil, rec_artists = nil)
    @festival = params
    @score = score
    @top_artists = top_artists
    @rec_artists = rec_artists
  end

  def self.all(artists)
    festivals = FestivalEngine.new(artists).unique_festivals
    festivals.map do |festival|
      Festival.new(festival)
    end.sort_by(&:start_date)
  end

  def self.top_festivals(all_artists)
    festivals = FestivalEngine.new(all_artists).top_5_festivals
    festivals.map do |festival|
      Festival.new(
        festival,
        festival[:score],
        festival[:top_artists],
        festival[:rec_artists]
      )
    end
  end

  def name
    festival[:displayName]
  end

  def start_date
    festival[:start][:date]
  end

  def end_date
    festival[:end][:date]
  end

  def url
    festival[:uri]
  end

  def location
    festival[:location][:city]
  end

  private

  attr_reader :festival
end
