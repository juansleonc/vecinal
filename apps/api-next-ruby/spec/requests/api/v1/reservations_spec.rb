require 'rails_helper'

RSpec.describe 'Reservations API', type: :request do
  describe 'GET /api/v1/reservations' do
    it 'returns an empty array' do
      get '/api/v1/reservations'
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json).to be_an(Array)
      expect(json).to be_empty
    end
  end

  describe 'GET /api/v1/reservations/:id' do
    it 'returns 404 for now' do
      get '/api/v1/reservations/123'
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST /api/v1/reservations' do
    let(:body) do
      {
        reservation: {
          amenityId: SecureRandom.uuid,
          date: Date.today.to_s,
          timeFrom: '10:00',
          timeTo: '11:00',
          message: 'Reserva de prueba'
        }
      }
    end

    it 'creates a reservation skeleton and returns 201' do
      post '/api/v1/reservations', params: body
      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json['id']).to be_present
      expect(json['status']).to eq('pending')
      expect(json['amenityId']).to eq(body[:reservation][:amenityId])
    end

    it 'validates required fields' do
      post '/api/v1/reservations', params: { reservation: {} }
      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json['errors']).to be_an(Array)
      expect(json['errors']).not_to be_empty
    end
  end

  describe 'PATCH /api/v1/reservations/:id' do
    it 'updates status when valid' do
      patch '/api/v1/reservations/abc', params: { reservation: { status: 'approved' } }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['ok']).to be true
    end

    it 'rejects invalid status' do
      patch '/api/v1/reservations/abc', params: { reservation: { status: 'invalid' } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'DELETE /api/v1/reservations/:id' do
    it 'returns 204' do
      delete '/api/v1/reservations/abc'
      expect(response).to have_http_status(:no_content)
    end
  end
end
