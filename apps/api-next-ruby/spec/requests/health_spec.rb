require 'rails_helper'

RSpec.describe 'Health endpoints', type: :request do
  it 'returns ok on /health' do
    get '/health'
    expect(response).to have_http_status(:ok)
    json = JSON.parse(response.body)
    expect(json['status']).to eq('ok')
  end

  it 'returns ok and version on /api/v1/health' do
    get '/api/v1/health'
    expect(response).to have_http_status(:ok)
    json = JSON.parse(response.body)
    expect(json['status']).to eq('ok')
    expect(json['version']).to be_present
  end
end
