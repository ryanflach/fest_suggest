class User < ApplicationRecord
  validates :username, presence: true, uniqueness: true
  validates :access_token, presence: true
  validates :refresh_token, presence: true
  validates :token_expiry, presence: true

  def self.process_spotify_user(data)
    if find_by_username(data[:username])
      update(
        access_token: data[:access_token],
        refresh_token: data[:refresh_token],
        token_expiry: data[:token_expiry]
      ).first
    else
      create(data)
    end
  end
end
