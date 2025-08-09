require 'rails_helper'

RSpec.describe 'Auth API', type: :request do
  describe 'POST /api/v1/auth/signup' do
    it 'creates a user and returns a token' do
      post '/api/v1/auth/signup', params: { email: 'user@example.com', password: 'secret123' }
      validate_response(status: 201)
      json = JSON.parse(response.body)
      expect(json['accessToken']).to be_present
      expect(json['refreshToken']).to be_present
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
      expect(json['accessToken']).to be_present
      expect(json['refreshToken']).to be_present
    end

    it 'rejects invalid credentials' do
      post '/api/v1/auth/login', params: { email: 'nope@example.com', password: 'wrong' }
      validate_response(status: 401)
    end
  end

  describe 'POST /api/v1/auth/refresh' do
    it 'issues a new access token from a valid refresh' do
      post '/api/v1/auth/signup', params: { email: 'r1@example.com', password: 'secret123' }
      json = JSON.parse(response.body)
      rt = json['refreshToken']
      post '/api/v1/auth/refresh', params: { refreshToken: rt }
      validate_response(status: 200)
      body = JSON.parse(response.body)
      expect(body['accessToken']).to be_present
    end
  end

  describe 'POST /api/v1/auth/logout' do
    it 'revokes a refresh token' do
      post '/api/v1/auth/signup', params: { email: 'r2@example.com', password: 'secret123' }
      json = JSON.parse(response.body)
      rt = json['refreshToken']
      post '/api/v1/auth/logout', params: { refreshToken: rt }
      expect(response).to have_http_status(:no_content)
    end
  end
end
