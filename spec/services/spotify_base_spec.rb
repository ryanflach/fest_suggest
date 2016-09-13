require 'rails_helper'

RSpec.describe 'Spotify Base' do
  it 'parses a JSON response' do
    sample_response = "{\n
      \"display_name\" : null,\n
      \"external_urls\" : {\n
      \"spotify\" : \"https://open.spotify.com/user/test\"\n  },\n
      \"followers\" : {\n
      \"href\" : null,\n
      \"total\" : 1\n  },\n
      \"href\" : \"https://api.spotify.com/v1/users/test\",\n
      \"id\" : \"test\",\n
      \"images\" : [ ],\n
      \"type\" : \"user\",\n
      \"uri\" : \"spotify:user:test\"\n}"

    parsed = Base.new.parse(sample_response)

    expect(parsed[:id]).to eq('test')
  end
end
