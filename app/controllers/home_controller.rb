class HomeController < ApplicationController
  before_action :refresh_expired_token

  def index
  end
end
