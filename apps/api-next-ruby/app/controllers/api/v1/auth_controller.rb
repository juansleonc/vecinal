class Api::V1::AuthController < ApplicationController
  skip_authentication :signup, :login

  def signup
    params.require(:email)
    params.require(:password)
    user = User.create!(email: params[:email], password: params[:password])
    token = Authentication.issue_token(user_id: user.id)
    render json: { token: token, user: { id: user.id, email: user.email } }, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: 'invalid', message: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  def login
    params.require(:email)
    params.require(:password)
    user = User.find_by(email: params[:email])
    unless user&.authenticate(params[:password])
      render json: { error: 'invalid_credentials' }, status: :unauthorized
      return
    end
    token = Authentication.issue_token(user_id: user.id)
    render json: { token: token, user: { id: user.id, email: user.email } }
  end
end
