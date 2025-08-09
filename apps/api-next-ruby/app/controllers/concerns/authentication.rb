module Authentication
  extend ActiveSupport::Concern

  SECRET = ENV.fetch('JWT_SECRET') { 'dev-secret-change-me' }
  ALGORITHM = 'HS256'

  included do
    before_action :authenticate_request!
  end

  def authenticate_request!
    token = request.headers['Authorization']&.to_s&.split(' ')&.last
    render json: { error: 'unauthorized' }, status: :unauthorized and return if token.blank?

    payload, _ = JWT.decode(token, SECRET, true, { algorithm: ALGORITHM })
    @current_user_id = payload['sub']
  rescue JWT::DecodeError
    render json: { error: 'unauthorized' }, status: :unauthorized
  end

  def current_user_id
    @current_user_id
  end

  module ClassMethods
    def skip_authentication(*actions)
      skip_before_action :authenticate_request!, only: actions
    end
  end

  module_function

  def issue_token_pair(user_id:, access_exp: 15.minutes.from_now, refresh_exp: 30.days.from_now)
    access_payload = { sub: user_id, exp: access_exp.to_i, iat: Time.now.to_i, typ: 'access' }
    access_token = JWT.encode(access_payload, SECRET, ALGORITHM)

    rt = RefreshToken.create!(user_id: user_id, expires_at: refresh_exp)
    [access_token, rt]
  end
end
