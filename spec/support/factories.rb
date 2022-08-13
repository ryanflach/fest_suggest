FactoryGirl.define do
  factory :user do
    username { 'test' }
    access_token { ENV['ACCESS_TOKEN'] }
    refresh_token { ENV['REFRESH_TOKEN'] }
    token_expiry { ENV['TOKEN_EXPIRY'] }
  end
end
