require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:username) }
  it { should validate_uniqueness_of(:username) }
  it { should validate_presence_of(:access_token) }
  it { should validate_presence_of(:refresh_token) }
  it { should validate_presence_of(:token_expiry) }

  it "can return the site admin" do
    admin = User.site_admin
    expect(admin).to be_a(User)
    expect(admin.username).to eq('festsuggest')
  end
end
