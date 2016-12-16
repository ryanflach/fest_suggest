class HomeController < ApplicationController
  before_action :refresh_expired_tokens

  def index
  end
end
