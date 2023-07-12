# frozen_string_literal: true

namespace :dev do
  desc 'Generate a development token'
  task generate_token: :environment do
    raise 'Test it only on development environment' unless Rails.env.development?

    require_relative '../../spec/support/authorization_helper'
    include AuthorizationHelper

    puts bearer_token_mock
  end
end
