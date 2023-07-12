# frozen_string_literal: true

RSpec.shared_context 'with authorization header', type: :request do
  let(:Authorization) { bearer_token_mock }

  let(:current_user) { build(:user_entity) }
end

module AuthorizationHelper
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

RSpec.configure do |config|
  config.include AuthorizationHelper, type: :request
end
