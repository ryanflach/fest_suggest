class CreatePlaylists < ActiveRecord::Migration[5.0]
  def change
    create_table :playlists do |t|
      t.text :name
      t.text :spotify_id
    end
  end
end
