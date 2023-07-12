# frozen_string_literal: true

module AuthorizeMock
  def bearer_token_mock(exp: 24.hours.from_now.to_i)
    payload = {
      sub: 'dbdc2419-f6cf-49c8-a545-a908a03741ce',
      name: 'John Doe',
      exp:,
      iss: 'auth',
      aud: 'quiz'
    }

    "Bearer #{AuthAdapter.encode(payload)}"
  end
end
