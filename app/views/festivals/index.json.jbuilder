json.(@festivals) do |festival|
  json.name festival.name
  json.location festival.location
  json.start_date festival.start_date
  json.end_date festival.end_date
  json.url festival.url
  json.other_artists_count festival.other_artists_count
  json.top_artists festival.top_artists do |artist|
    json.name artist.name
  end
  json.rec_artists festival.rec_artists do |artist|
    json.name artist.name
  end
end
