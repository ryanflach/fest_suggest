class UserEngine
  def initialize(user)
    @user    = user
    @service = Spotify::AuthService.new
    update_user_tokens
  end

  def self.update_user(user)
    new(user)
  end

  private

  attr_reader :service,
              :user

  def token_expired?
    user.token_expiry < Time.now
  end

  def get_new_tokens
    service.refresh_user_tokens(user.refresh_token)
  end

  def update_user_tokens
    user.update(get_new_tokens) if user && token_expired?
  end
end
