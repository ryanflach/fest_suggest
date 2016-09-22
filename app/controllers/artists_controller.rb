class ArtistsController < ApplicationController
  def index
    @artists = Cacher.new(current_user, params[:range])
                     .process_artist_cache
  end
end
