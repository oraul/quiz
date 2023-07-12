# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Authorizable do
  include AuthorizeMock

  subject(:authorizable) { dummy_class(authorization) }

  describe '.authorize_user' do
    subject(:authorize_user!) { authorizable.authorize_user! }

    context 'with valid token' do
      before { authorize_user! }

      let(:authorization) { bearer_token_mock }

      let(:attributes) do
        {
          sub: 'dbdc2419-f6cf-49c8-a545-a908a03741ce',
          name: 'John Doe',
          exp: instance_of(Integer),
          iss: 'auth',
          aud: 'quiz'
        }
      end

      it { expect(authorizable.current_user).to be_instance_of(UserEntity) }

      it { expect(authorizable.current_user).to have_attributes(attributes) }
    end

    context 'without token' do
      let(:authorization) { nil }

      it { expect { authorize_user! }.to raise_error(authorizable.class::AuthorizationError, 'Token not set') }
    end

    context 'with incomplete token' do
      let(:authorization) { 'Bearer ' }

      it { expect { authorize_user! }.to raise_error(authorizable.class::AuthorizationError, 'Token not set') }
    end

    context 'with invalid token' do
      let(:authorization) { 'Bearer invalid' }

      it { expect { authorize_user! }.to raise_error(JWT::DecodeError) }
    end
  end

  def dummy_class(authorization)
    Class.new do
      include Authorizable

      def initialize(authorization)
        @authorization = authorization
      end

      def request
        @request ||= Struct.new(:headers).new({ 'Authorization' => @authorization })
      end
    end.new(authorization)
  end
end
