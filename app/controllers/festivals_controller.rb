class FestivalsController < ApplicationController
  def index
    artists = Artist.all(current_user, params[:range])
    @festivals = Festival.all(artists)
  end
end
