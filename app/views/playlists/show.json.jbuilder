json.playlist do
  json.name @playlist.name
  json.spotify_id @playlist.spotify_id
  json.followed @playlist.is_followed?(current_user)
end
