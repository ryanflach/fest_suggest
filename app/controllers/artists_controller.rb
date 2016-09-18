class ArtistsController < ApplicationController
  def index
    @artists = Artist.top_spotify_artists(current_user, params[:range])
    render json: @artists
  end
end
