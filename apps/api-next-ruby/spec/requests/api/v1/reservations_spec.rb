require 'rails_helper'

RSpec.describe 'Reservations API', type: :request do
  describe 'GET /api/v1/reservations' do
    it 'returns an empty array' do
      get '/api/v1/reservations'
      validate_response(status: 200)
      json = JSON.parse(response.body)
      expect(json).to be_an(Array)
      expect(json).to be_empty
    end
  end

  describe 'GET /api/v1/reservations/:id' do
    it 'returns 404 for missing id' do
      get '/api/v1/reservations/00000000-0000-0000-0000-000000000000'
      validate_response(status: 404)
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

    it 'creates a reservation and returns 201' do
      post '/api/v1/reservations', params: body
      validate_response(status: 201)
      json = JSON.parse(response.body)
      expect(json['id']).to be_present
      expect(json['status']).to eq('pending')
      expect(json['amenityId']).to eq(body[:reservation][:amenityId])
    end

    it 'validates required fields' do
      post '/api/v1/reservations', params: { reservation: {} }
      validate_response(status: 422)
      json = JSON.parse(response.body)
      expect(json['errors']).to be_an(Array)
      expect(json['errors']).not_to be_empty
    end
  end

  describe 'PATCH /api/v1/reservations/:id' do
    it 'updates status when valid' do
      patch '/api/v1/reservations/abc', params: { reservation: { status: 'approved' } }
      validate_response(status: 200)
      json = JSON.parse(response.body)
      expect(json['ok']).to be true
    end

    it 'rejects invalid status' do
      patch '/api/v1/reservations/abc', params: { reservation: { status: 'invalid' } }
      validate_response(status: 422)
    end
  end

  describe 'DELETE /api/v1/reservations/:id' do
    it 'returns 204' do
      delete '/api/v1/reservations/abc'
      expect(response).to have_http_status(:no_content)
    end
  end
end
