json.playlist do
  json.name @playlist.name
  json.spotify_id @playlist.spotify_id
  json.followed @playlist.followed?(current_user)
end
