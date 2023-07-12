# frozen_string_literal: true

module Authorizable
  extend ActiveSupport::Concern

  class AuthorizationError < StandardError; end

  included do
    attr_reader :current_user

    def authorize_user!
      token = request.headers['Authorization']&.scan(/Bearer (.+)/)&.first&.first

      raise AuthorizationError, 'Token not set' if token.blank?

      @current_user = UserEntity.new(
        AuthAdapter.decode(token)
      )
    end
  end
end
