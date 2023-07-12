# frozen_string_literal: true

class AuthAdapter
  class << self
    SECRET_KEY = Rails.application.credentials.config[:auth_adapter][:secret_key]

    def encode(payload)
      JWT.encode(payload, SECRET_KEY)
    end

    def decode(token)
      JWT.decode(token, SECRET_KEY, true, algorithm: 'HS256').first
    end
  end
end
