require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  it 'returns current user profile on /api/v1/me' do
    user = User.create!(email: 'me@example.com', password: 'secret123')
    token = Authentication.issue_token_pair(user_id: user.id).first
    get '/api/v1/me', headers: { 'Authorization' => "Bearer #{token}" }
    validate_response(status: 200)
    json = JSON.parse(response.body)
    expect(json['id']).to eq(user.id)
    expect(json['email']).to eq('me@example.com')
    expect(json['roles']).to be_an(Array)
  end
end
