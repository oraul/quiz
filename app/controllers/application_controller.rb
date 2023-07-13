# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::Caching

  include Authorizable

  rescue_from AuthorizationError, with: :authorization_error
  rescue_from JWT::DecodeError, with: :authorization_error
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  before_action :authorize_user!

  def authorization_error
    render json: { message: I18n.t('error.message.authorization_error') }, status: :unauthorized
  end

  def record_not_found
    render json: { message: I18n.t('error.message.record_not_found') }, status: :not_found
  end
end
