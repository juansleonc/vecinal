require 'rails_helper'

RSpec.describe 'JWKS', type: :request do
  it 'exposes a JWKS with at least 1 key' do
    get '/.well-known/jwks.json'
    validate_response(status: 200)
    json = JSON.parse(response.body)
    expect(json['keys']).to be_an(Array)
    expect(json['keys'].length).to be >= 1
    expect(json['keys'][0]['kid']).to be_present
  end
end
