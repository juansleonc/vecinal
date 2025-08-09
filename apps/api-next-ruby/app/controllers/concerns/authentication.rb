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

  def issue_token(user_id:, exp: 24.hours.from_now)
    payload = { sub: user_id, exp: exp.to_i, iat: Time.now.to_i }
    JWT.encode(payload, SECRET, ALGORITHM)
  end
end
