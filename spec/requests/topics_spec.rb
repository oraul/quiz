# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe '/topics' do
  path '/topics' do
    get 'Retrieves topic list' do
      tags 'Topics'

      produces 'application/json'

      response '200', 'topic found' do
        schema type: :array,
               items: { '$ref' => '#/components/schemas/Topic' }

        let(:topic) { create(:topic) }

        run_test!
      end

      response(401, 'unauthorized') do
        schema '$ref' => '#/components/schemas/UnauthorizedError'

        let(:Authorization) { nil }

        run_test!
      end
    end

    post 'Creates a topic' do
      tags 'Topics'

      produces 'application/json'
      consumes 'application/json'

      parameter name: :topic, in: :body, schema: { '$ref' => '#/components/schemas/Topic' }

      response '201', 'topic created' do
        schema '$ref' => '#/components/schemas/Topic'

        let(:topic) do
          { name: "Topic #{Time.zone.now}", discipline_id: create(:discipline).id }
        end

        it 'returns a 201 response' do |example|
          expect { submit_request(example.metadata) }.to change(Topic, :count).by(1)

          assert_response_matches_metadata(example.metadata)
        end
      end

      response(401, 'unauthorized') do
        schema '$ref' => '#/components/schemas/UnauthorizedError'

        let(:Authorization) { nil }

        let(:topic) { {} }

        run_test!
      end

      response '422', 'invalid request' do
        schema '$ref' => '#/components/schemas/TopicError'

        let(:topic) do
          { name: nil, discipline_id: nil }
        end

        it 'returns a 422 response' do |example|
          expect { submit_request(example.metadata) }.not_to change(Topic, :count)

          assert_response_matches_metadata(example.metadata)
        end
      end
    end
  end

  path '/topics/{id}' do
    get 'Retrieves a topic' do
      tags 'Topics'

      produces 'application/json'

      parameter name: :id, in: :path, type: :string

      response '200', 'topic found' do
        schema '$ref' => '#/components/schemas/Topic'

        let(:id) { create(:topic).id }

        run_test!
      end

      response(401, 'unauthorized') do
        schema '$ref' => '#/components/schemas/UnauthorizedError'

        let(:Authorization) { nil }

        let(:id) { 'id' }

        run_test!
      end

      response '404', 'topic not found' do
        schema '$ref' => '#/components/schemas/RecordNotFoundError'

        let(:id) { 'unknown' }

        run_test!
      end
    end

    patch 'Updates a topic' do
      tags 'Topics'

      consumes 'application/json'
      produces 'application/json'

      parameter name: :id, in: :path, type: :string
      parameter name: :topic, in: :body, schema: { '$ref' => '#/components/schemas/Topic' }

      let(:record) { create(:topic) }

      let(:id) { record.id }

      response '200', 'topic updated' do
        schema '$ref' => '#/components/schemas/Topic'

        let(:topic) do
          { name: "Topic #{Time.zone.now}", discipline_id: create(:discipline).id }
        end

        it 'returns a 200 response' do |example|
          submit_request(example.metadata)

          expect(record.reload).to have_attributes(**topic)

          assert_response_matches_metadata(example.metadata)
        end
      end

      response(401, 'unauthorized') do
        schema '$ref' => '#/components/schemas/UnauthorizedError'

        let(:Authorization) { nil }

        let(:topic) { {} }

        run_test!
      end

      response '422', 'invalid request' do
        schema '$ref' => '#/components/schemas/TopicError'

        let(:topic) do
          { name: nil, discipline_id: nil }
        end

        run_test!
      end
    end

    delete 'Deletes a topic' do
      tags 'Topics'

      consumes 'application/json'

      parameter name: :id, in: :path, type: :string

      response '204', 'topic deleted' do
        let(:id) { create(:topic).id }

        it 'returns a 204 response' do |example|
          expect { submit_request(example.metadata) }.to change { Topic.where(id:).count }.by(-1)

          assert_response_matches_metadata(example.metadata)
        end
      end

      response(401, 'unauthorized') do
        schema '$ref' => '#/components/schemas/UnauthorizedError'

        let(:Authorization) { nil }

        let(:id) { 'id' }

        run_test!
      end

      response '404', 'topic not found' do
        let(:id) { 'unknown' }

        run_test!
      end
    end
  end
end
