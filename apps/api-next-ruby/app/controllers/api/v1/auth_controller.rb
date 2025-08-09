class Api::V1::AuthController < ApplicationController
  skip_authentication :signup, :login

  def signup
    params.require(:email)
    params.require(:password)
    user = User.create!(email: params[:email], password: params[:password])
    access_token, refresh_token = Authentication.issue_token_pair(user_id: user.id)
    render json: { accessToken: access_token, refreshToken: refresh_token.token, user: { id: user.id, email: user.email } }, status: :created
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
    access_token, refresh_token = Authentication.issue_token_pair(user_id: user.id)
    render json: { accessToken: access_token, refreshToken: refresh_token.token, user: { id: user.id, email: user.email } }
  end

  def refresh
    params.require(:refreshToken)
    RefreshToken.transaction do
      rt = RefreshToken.active.find_by!(token: params[:refreshToken])
      # One-time use: revoke current refresh and issue a new pair
      rt.revoke!
      access_token, new_rt = Authentication.issue_token_pair(user_id: rt.user_id)
      render json: { accessToken: access_token, refreshToken: new_rt.token }
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'invalid_refresh' }, status: :unauthorized
  end

  def logout
    params.require(:refreshToken)
    rt = RefreshToken.find_by(token: params[:refreshToken])
    rt&.revoke!
    head :no_content
  end
end
