class Spotify::Base
  def parse(response)
    JSON.parse(response.body, symbolize_names: true)
  end
end
