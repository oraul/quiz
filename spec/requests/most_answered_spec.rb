# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe '/most_answered' do
  path '/most_answered/disciplines' do
    get 'Retrieves most answered discipline list' do
      tags 'Most Answered'

      produces 'application/json'

      response '200', 'most answered found' do
        schema type: :array,
               items: { '$ref' => '#/components/schemas/MostAnsweredDiscipline' }

        before { create(:answer) }

        run_test!
      end

      response(401, 'unauthorized') do
        schema '$ref' => '#/components/schemas/UnauthorizedError'

        let(:Authorization) { nil }

        run_test!
      end
    end
  end
end
