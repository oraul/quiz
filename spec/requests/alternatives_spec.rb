# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe '/alternatives' do
  path '/alternatives/{id}' do
    get 'Retrieves an alternative' do
      tags 'Alternatives'

      produces 'application/json'

      parameter name: :id, in: :path, type: :string

      response '200', 'alternative found' do
        schema '$ref' => '#/components/schemas/Alternative'

        let(:id) { create(:alternative).id }

        run_test!
      end

      response(401, 'unauthorized') do
        schema '$ref' => '#/components/schemas/UnauthorizedError'

        let(:Authorization) { nil }

        let(:id) { 'id' }

        run_test!
      end

      response '404', 'alternative not found' do
        schema '$ref' => '#/components/schemas/RecordNotFoundError'

        let(:id) { 'unknown' }

        run_test!
      end
    end
  end
end
