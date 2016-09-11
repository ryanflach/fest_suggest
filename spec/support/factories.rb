FactoryGirl.define do
  factory :user do
    username 'test'
    access_token '1234'
    refresh_token '5678'
    token_expiry Time.now + 3600
  end
end
