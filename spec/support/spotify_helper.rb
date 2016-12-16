module SpotifyHelper
  def token_expired?
    ENV['TOKEN_EXPIRY'] < Time.now
  end

  def refresh_access_tokens
    refresh_access_token('base')
    refresh_access_token('site')
  end

  def refresh_access_token(user)
    prefix = user == 'base' ? nil : 'FS_'
    new_tokens = Spotify::AuthService.new
                                     .refresh_user_tokens(
                                       ENV["#{prefix}REFRESH_TOKEN"]
                                     )
    update_yml_file(new_tokens, prefix)
  end

  def update_yml_file(tokens, prefix)
    data = YAML.load_file('config/application.yml')
    data['test']["#{prefix}ACCESS_TOKEN"] = tokens[:access_token]
    data['test']["#{prefix}TOKEN_EXPIRY"] = tokens[:token_expiry]
    data['test']["#{prefix}REFRESH_TOKEN"] =
      tokens[:refresh_token] if tokens[:refresh_token]
    File.open('config/application.yml', 'w') do |file|
      YAML.dump(data, file)
    end
  end
end
