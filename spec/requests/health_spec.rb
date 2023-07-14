# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe '/health' do
  path '/health' do
    get 'Retrieves application health' do
      tags 'Health'

      produces 'application/json'

      response '204', 'application is health' do
        run_test!
      end
    end
  end
end
