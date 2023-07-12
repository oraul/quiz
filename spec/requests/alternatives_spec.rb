# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe '/alternatives' do
  path '/alternatives' do
    get 'Retrieves alternative list' do
      tags 'Alternatives'

      produces 'application/json'

      response '200', 'alternative found' do
        schema type: :array,
               items: { '$ref' => '#/components/schemas/Alternative' }

        let(:question) { create(:alternative) }

        run_test!
      end

      response(401, 'unauthorized') do
        schema '$ref' => '#/components/schemas/UnauthorizedError'

        let(:Authorization) { nil }

        run_test!
      end
    end

    post 'Creates an alternative' do
      tags 'Alternatives'

      produces 'application/json'
      consumes 'application/json'

      parameter name: :alternative, in: :body, schema: { '$ref' => '#/components/schemas/Alternative' }

      response '201', 'alternative created' do
        let(:alternative) do
          { description: "Alternative #{Time.zone.now}", question_id: create(:question).id }
        end

        it 'returns a 201 response' do |example|
          expect { submit_request(example.metadata) }.to change(Alternative, :count).by(1)

          assert_response_matches_metadata(example.metadata)
        end
      end

      response(401, 'unauthorized') do
        schema '$ref' => '#/components/schemas/UnauthorizedError'

        let(:alternative) { {} }

        let(:Authorization) { nil }

        run_test!
      end

      response '422', 'invalid request' do
        schema '$ref' => '#/components/schemas/AlternativeError'

        let(:alternative) do
          { description: nil, correct: nil, question_id: nil }
        end

        it 'returns a 422 response' do |example|
          expect { submit_request(example.metadata) }.not_to change(Alternative, :count)

          assert_response_matches_metadata(example.metadata)
        end
      end
    end
  end

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

    patch 'Updates an alternative' do
      tags 'Alternatives'

      consumes 'application/json'
      produces 'application/json'

      parameter name: :id, in: :path, type: :string
      parameter name: :alternative, in: :body, schema: { '$ref' => '#/components/schemas/Alternative' }

      let(:record) { create(:alternative) }

      let(:id) { record.id }

      response '200', 'alternative updated' do
        let(:alternative) do
          { description: "Alternative #{Time.zone.now}" }
        end

        it 'returns a 200 response' do |example|
          submit_request(example.metadata)

          expect(record.reload).to have_attributes(**alternative)

          assert_response_matches_metadata(example.metadata)
        end
      end

      response(401, 'unauthorized') do
        schema '$ref' => '#/components/schemas/UnauthorizedError'

        let(:alternative) { {} }

        let(:Authorization) { nil }

        run_test!
      end

      response '422', 'invalid request' do
        schema '$ref' => '#/components/schemas/AlternativeError'

        let(:alternative) do
          { description: nil, correct: nil, question_id: nil }
        end

        run_test!
      end
    end

    delete 'Deletes a alternative' do
      tags 'Alternatives'

      consumes 'application/json'

      parameter name: :id, in: :path, type: :string

      response '204', 'alternative deleted' do
        let(:id) { create(:alternative).id }

        it 'returns a 204 response' do |example|
          expect { submit_request(example.metadata) }.to change { Alternative.where(id:).count }.by(-1)

          assert_response_matches_metadata(example.metadata)
        end
      end

      response(401, 'unauthorized') do
        schema '$ref' => '#/components/schemas/UnauthorizedError'

        let(:id) { 'id' }

        let(:alternative) { {} }

        let(:Authorization) { nil }

        run_test!
      end

      response '404', 'alternative not found' do
        let(:id) { 'unknown' }

        run_test!
      end
    end
  end
end
