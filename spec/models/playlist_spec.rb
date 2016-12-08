require 'rails_helper'

RSpec.describe Playlist, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:spotify_id) }
  it { should validate_uniqueness_of(:spotify_id) }

  it 'finds or creates a playlist from festival data' do
    expect(Playlist.count).to eq(0)

    list = Playlist.create!(name: 'test', spotify_id: 'unique_id')

    expect(Playlist.count).to eq(1)
    expect(Playlist.find_or_create({ displayName: 'test' })).to eq(list)

    allow_any_instance_of(PlaylistEngine)
      .to receive(:create_playlist)
      .and_return('1')
    other = Playlist.find_or_create({
      displayName: 'none',
      performance: []
    })

    expect(Playlist.count).to eq(2)
    expect(other.spotify_id).to eq('1')
    expect(other.name).to eq('none')
  end
end
