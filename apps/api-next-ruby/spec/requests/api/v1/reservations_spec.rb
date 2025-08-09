require 'rails_helper'

RSpec.describe 'Reservations API', type: :request do
  describe 'GET /api/v1/reservations' do
    it 'returns an empty list with meta' do
      get '/api/v1/reservations'
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['data']).to be_an(Array)
      expect(json['data']).to be_empty
      expect(json['meta']).to include('count' => 0)
    end
  end

  describe 'GET /api/v1/reservations/:id' do
    it 'returns 404 for now' do
      get '/api/v1/reservations/123'
      expect(response).to have_http_status(:not_found)
    end
  end
end
