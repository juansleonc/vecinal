class Rack::Attack
  throttle('auth/ip', limit: (ENV.fetch('AUTH_THROTTLE_PER_MIN', '20')).to_i, period: 1.minute) do |req|
    if req.path.start_with?('/api/v1/auth') && req.post?
      req.ip
    end
  end

  throttle('auth/email', limit: (ENV.fetch('AUTH_THROTTLE_PER_MIN_PER_EMAIL', '10')).to_i, period: 1.minute) do |req|
    if req.path.start_with?('/api/v1/auth') && req.post?
      Rack::Utils.parse_nested_query(req.body.read)['email']&.downcase
    end
  end
end

Rails.application.config.middleware.use Rack::Attack
