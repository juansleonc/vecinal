class Jwks
  # In a production setup, keep private keys in a KMS/HSM. Here we generate or read from ENV.
  # Support multiple keys for rotation. Header `kid` selects the key.

  Key = Struct.new(:kid, :private_pem, :public_jwk, keyword_init: true)

  def self.current_keys
    # Expect ENV JWT_PRIVATE_KEYS as JSON array of {kid, pem}, fallback to single HS secret (not ideal for JWKS)
    rsa_keys = load_rsa_keys
    rsa_keys.map(&:public_jwk)
  end

  def self.sign(payload, kid: nil, exp: 15.minutes.from_now)
    key = pick_key(kid)
    payload = payload.merge(exp: exp.to_i, iat: Time.now.to_i)
    JWT.encode(payload, OpenSSL::PKey::RSA.new(key.private_pem), 'RS256', { kid: key.kid })
  end

  def self.verify(token)
    header = JWT.decode(token, nil, false).last # header only
    kid = header['kid']
    key = load_rsa_keys.find { |k| k.kid == kid }
    raise JWT::VerificationError, 'unknown kid' unless key
    JWT.decode(token, OpenSSL::PKey::RSA.new(key.private_pem).public_key, true, { algorithm: 'RS256' })
  end

  def self.load_rsa_keys
    raw = ENV['JWT_PRIVATE_KEYS']
    return default_dev_keys if raw.blank?
    arr = JSON.parse(raw)
    arr.map do |entry|
      rsa = OpenSSL::PKey::RSA.new(entry['pem'])
      jwk = JWT::JWK.create_from(rsa.public_key, kid: entry['kid']).export
      Key.new(kid: entry['kid'], private_pem: entry['pem'], public_jwk: jwk)
    end
  end

  def self.pick_key(kid)
    keys = load_rsa_keys
    return keys.first if kid.nil?
    keys.find { |k| k.kid == kid } || keys.first
  end

  def self.default_dev_keys
    rsa = OpenSSL::PKey::RSA.generate(2048)
    kid = 'dev-key'
    jwk = JWT::JWK.create_from(rsa.public_key, kid: kid).export
    [Key.new(kid: kid, private_pem: rsa.to_pem, public_jwk: jwk)]
  end
end
