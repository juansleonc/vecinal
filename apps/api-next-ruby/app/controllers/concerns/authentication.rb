module Authentication
  extend ActiveSupport::Concern

  SECRET = ENV.fetch('JWT_SECRET', nil)
  ALGORITHM = ENV.fetch('JWT_ALG', 'RS256')

  included do
    before_action :authenticate_request!
  end

  def authenticate_request!
    token = request.headers['Authorization']&.to_s&.split(' ')&.last
    render json: { error: 'unauthorized' }, status: :unauthorized and return if token.blank?

    payload, _ = if ALGORITHM == 'HS256'
                   JWT.decode(token, SECRET, true, { algorithm: 'HS256' })
                 else
                   Jwks.verify(token)
                 end
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
    access_payload = { sub: user_id, typ: 'access' }
    access_token = if ALGORITHM == 'HS256'
                     JWT.encode(access_payload.merge(exp: access_exp.to_i, iat: Time.now.to_i), SECRET, 'HS256')
                   else
                     Jwks.sign(access_payload, exp: access_exp)
                   end

    rt = RefreshToken.create!(user_id: user_id, expires_at: refresh_exp)
    [access_token, rt]
  end
end
