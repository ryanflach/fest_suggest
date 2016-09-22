class FestivalsController < ApplicationController
  def index
    @festivals = Cacher.new(current_user, params[:range])
                       .process_festival_cache
  end
end
