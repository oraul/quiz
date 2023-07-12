# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe '/questions' do
  path '/questions' do
    get 'Retrieves question list' do
      tags 'Questions'

      produces 'application/json'

      response '200', 'question found' do
        let(:question) { create(:question) }

        schema type: :array,
               items: { '$ref' => '#/components/schemas/Question' }

        run_test!
      end

      response(401, 'unauthorized') do
        schema '$ref' => '#/components/schemas/UnauthorizedError'

        let(:Authorization) { nil }

        run_test!
      end
    end

    post 'Creates a question' do
      tags 'Questions'

      produces 'application/json'
      consumes 'application/json'

      parameter name: :question, in: :body, schema: { '$ref' => '#/components/schemas/Question' }

      response '201', 'question created' do
        let(:question) do
          { enunciation: "Question #{Time.zone.now}", topic_id: create(:topic).id }
        end

        it 'returns a 201 response' do |example|
          expect { submit_request(example.metadata) }.to change(Question, :count).by(1)

          assert_response_matches_metadata(example.metadata)
        end
      end

      response(401, 'unauthorized') do
        schema '$ref' => '#/components/schemas/UnauthorizedError'

        let(:Authorization) { nil }

        let(:question) { {} }

        run_test!
      end

      response '422', 'invalid request' do
        schema '$ref' => '#/components/schemas/QuestionError'

        let(:question) do
          { enunciation: nil, topic_id: nil }
        end

        it 'returns a 422 response' do |example|
          expect { submit_request(example.metadata) }.not_to change(Question, :count)

          assert_response_matches_metadata(example.metadata)
        end
      end
    end
  end

  path '/questions/{id}' do
    get 'Retrieves a question' do
      tags 'Questions'

      produces 'application/json'

      parameter name: :id, in: :path, type: :string

      response '200', 'question found' do
        let(:id) { create(:question).id }

        schema '$ref' => '#/components/schemas/Question'

        run_test!
      end

      response(401, 'unauthorized') do
        schema '$ref' => '#/components/schemas/UnauthorizedError'

        let(:Authorization) { nil }

        let(:id) { 'id' }

        run_test!
      end

      response '404', 'question not found' do
        schema '$ref' => '#/components/schemas/RecordNotFoundError'

        let(:id) { 'unknown' }

        run_test!
      end
    end

    patch 'Updates a question' do
      tags 'Questions'

      consumes 'application/json'
      produces 'application/json'

      parameter name: :id, in: :path, type: :string
      parameter name: :question, in: :body, schema: { '$ref' => '#/components/schemas/Question' }

      let(:record) { create(:question) }

      let(:id) { record.id }

      response '200', 'question updated' do
        let(:question) do
          { enunciation: "Question #{Time.zone.now}" }
        end

        it 'returns a 200 response' do |example|
          submit_request(example.metadata)

          expect(record.reload).to have_attributes(**question)

          assert_response_matches_metadata(example.metadata)
        end
      end

      response(401, 'unauthorized') do
        schema '$ref' => '#/components/schemas/UnauthorizedError'

        let(:Authorization) { nil }

        let(:question) { {} }

        run_test!
      end

      response '422', 'invalid request' do
        schema '$ref' => '#/components/schemas/QuestionError'

        let(:question) do
          { enunciation: nil, topic_id: nil }
        end

        run_test!
      end
    end

    delete 'Deletes a question' do
      tags 'Questions'

      consumes 'application/json'

      parameter name: :id, in: :path, type: :string

      response '204', 'question deleted' do
        let(:id) { create(:question).id }

        it 'returns a 204 response' do |example|
          expect { submit_request(example.metadata) }.to change { Question.where(id:).count }.by(-1)

          assert_response_matches_metadata(example.metadata)
        end
      end

      response(401, 'unauthorized') do
        schema '$ref' => '#/components/schemas/UnauthorizedError'

        let(:Authorization) { nil }

        let(:id) { 'id' }

        run_test!
      end

      response '404', 'question not found' do
        let(:id) { 'unknown' }

        run_test!
      end
    end
  end
end
