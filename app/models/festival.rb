class Festival
  def initialize(params)
    @festival = params
  end

  def self.all(artists)
    festivals = FestivalEngine.new(artists).unique_festivals
    festivals.map do |festival|
      Festival.new(festival)
    end.sort_by(&:start_date)
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

  private

  attr_reader :festival
end
