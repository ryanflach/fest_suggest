require 'rails_helper'

RSpec.describe Playlist, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:spotify_id) }
  it { should validate_uniqueness_of(:spotify_id) }
end
