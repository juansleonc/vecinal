require 'rails_helper'

RSpec.describe 'Auth API', type: :request do
  describe 'POST /api/v1/auth/signup' do
    it 'creates a user and returns a token' do
      post '/api/v1/auth/signup', params: { email: 'user@example.com', password: 'secret123' }
      validate_response(status: 201)
      json = JSON.parse(response.body)
      expect(json['token']).to be_present
      expect(json['user']['email']).to eq('user@example.com')
    end

    it 'fails on missing params' do
      post '/api/v1/auth/signup', params: { email: '' }
      validate_response(status: 400)
    end
  end

  describe 'POST /api/v1/auth/login' do
    it 'returns a token for valid credentials' do
      user = User.create!(email: 'login@example.com', password: 'secret123')
      post '/api/v1/auth/login', params: { email: 'login@example.com', password: 'secret123' }
      validate_response(status: 200)
      json = JSON.parse(response.body)
      expect(json['token']).to be_present
    end

    it 'rejects invalid credentials' do
      post '/api/v1/auth/login', params: { email: 'nope@example.com', password: 'wrong' }
      validate_response(status: 401)
    end
  end
end
