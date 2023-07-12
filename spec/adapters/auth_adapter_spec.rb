# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AuthAdapter, type: :adapter do
  subject(:auth_adapter) { described_class }

  let(:payload) do
    {
      sub: 'dbdc2419-f6cf-49c8-a545-a908a03741ce',
      name: 'John Doe',
      exp: 24.hours.from_now.to_i,
      iss: 'auth',
      aud: 'quiz'
    }
  end

  describe '#decode' do
    subject(:decode) { auth_adapter.decode(token) }

    context 'with valid token' do
      let(:token) { auth_adapter.encode(payload) }

      before do
        allow(JWT).to receive(:decode)
          .with(token, auth_adapter.singleton_class::SECRET_KEY, true, algorithm: 'HS256')
          .and_call_original
      end

      it { is_expected.to eq(payload.stringify_keys) }
    end

    context 'with invalid token' do
      let(:token) { 'invalid_token' }

      it { expect { decode }.to raise_error JWT::DecodeError }
    end
  end

  describe '#encode' do
    subject(:encode) { auth_adapter.encode(payload) }

    before do
      allow(JWT).to receive(:encode).with(payload, auth_adapter.singleton_class::SECRET_KEY).and_call_original

      encode
    end

    it { expect(JWT).to have_received(:encode).with(payload, auth_adapter.singleton_class::SECRET_KEY).once }

    it { is_expected.to be_instance_of(String) }
  end
end
