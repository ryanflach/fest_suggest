module SpotifyHelper
  def token_expired?
    ENV['TOKEN_EXPIRY'] < Time.now
  end

  def refresh_access_token
    new_tokens = Spotify::AuthService.new
                                     .refresh_user_tokens(
                                       ENV['REFRESH_TOKEN']
                                     )
    update_yml_file(new_tokens)
  end

  def update_yml_file(tokens)
    data = YAML.load_file('config/application.yml')
    data['test']['ACCESS_TOKEN'] = tokens[:access_token]
    data['test']['TOKEN_EXPIRY'] = tokens[:token_expiry]
    data['test']['REFRESH_TOKEN'] =
      tokens[:refresh_token] if tokens[:refresh_token]
    File.open('config/application.yml', 'w') do |file|
      YAML.dump(data, file)
    end
  end
end
