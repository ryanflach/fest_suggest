class FestivalsController < ApplicationController
  def index
    artists = Artist.all(current_user, params[:range])
    @festivals = Festival.top_festivals(artists)
  end
end
