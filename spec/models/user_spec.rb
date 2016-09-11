require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:username) }
  it { should validate_uniqueness_of(:username) }
  it { should validate_presence_of(:access_token) }
  it { should validate_presence_of(:refresh_token) }
  it { should validate_presence_of(:token_expiry) }
end
