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

  def self.site_admin
    find_or_create_by(username: ENV['FS_ADMIN_NAME']) do |user|
      user.access_token  = ENV['FS_ACCESS_TOKEN']
      user.refresh_token = ENV['FS_REFRESH_TOKEN']
      user.token_expiry  = Time.now - 3700
    end
  end
end
