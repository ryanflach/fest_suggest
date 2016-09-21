class FestivalsController < ApplicationController
  def index
    @festivals =
      FestCacher.new(current_user, params[:range]).process_cache
  end
end
