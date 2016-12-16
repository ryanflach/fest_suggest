class PlaylistsController < ApplicationController
  def show
    @playlist = Playlist.find_by_name(params[:name])
    if @playlist.nil?
      render json: { playlist: { followed: false } }
    end
  end

  def update
    festival = Rails.cache.fetch(params[:name])
    playlist = Playlist.find_or_create(festival)
    playlist.process_follow(current_user, playlist_params[:text])
  end

  private

  def playlist_params
    params.require(:playlist).permit(:text);
  end
end
