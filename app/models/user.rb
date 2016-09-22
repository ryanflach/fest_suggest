class User < ApplicationRecord
  validates :username, presence: true, uniqueness: true
  validates :access_token, presence: true
  validates :refresh_token, presence: true
  validates :token_expiry, presence: true

  def self.process_spotify_user(data)
    user = find_by_username(data[:username])
    if user
      user.update(
        access_token: data[:access_token],
        refresh_token: data[:refresh_token],
        token_expiry: data[:token_expiry]
      )
    else
      user = create(data)
    end
    user
  end
end
