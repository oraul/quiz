# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe '/answers' do
  path '/answers' do
    get 'Retrieves answer list' do
      tags 'Answers'

      produces 'application/json'

      response '200', 'answer found' do
        schema type: :array,
               items: { '$ref' => '#/components/schemas/Answer' }

        let(:answer) { create(:answer) }

        run_test!
      end

      response(401, 'unauthorized') do
        schema '$ref' => '#/components/schemas/UnauthorizedError'

        let(:Authorization) { nil }

        run_test!
      end
    end

    post 'Creates an answer' do
      tags 'Answers'

      produces 'application/json'
      consumes 'application/json'

      parameter name: :answer, in: :body, schema: { '$ref' => '#/components/schemas/Answer' }

      response '201', 'answer created' do
        let(:answer) do
          { user_id: current_user.sub, alternative_id: create(:alternative).id }
        end

        it 'returns a 201 response' do |example|
          expect { submit_request(example.metadata) }.to change(Answer, :count).by(1)

          assert_response_matches_metadata(example.metadata)
        end
      end

      response(401, 'unauthorized') do
        schema '$ref' => '#/components/schemas/UnauthorizedError'

        let(:answer) { {} }

        let(:Authorization) { nil }

        run_test!
      end

      response '422', 'invalid request' do
        schema '$ref' => '#/components/schemas/AnswerError'

        let(:answer) do
          { user_id: nil, alternative_id: nil }
        end

        it 'returns a 422 response' do |example|
          expect { submit_request(example.metadata) }.not_to change(Answer, :count)

          assert_response_matches_metadata(example.metadata)
        end
      end
    end
  end

  path '/answers/{id}' do
    get 'Retrieves an answer' do
      tags 'Answers'

      produces 'application/json'

      parameter name: :id, in: :path, type: :string

      response '200', 'answer found' do
        schema '$ref' => '#/components/schemas/Answer'

        let(:id) { create(:answer).id }

        run_test!
      end

      response(401, 'unauthorized') do
        schema '$ref' => '#/components/schemas/UnauthorizedError'

        let(:Authorization) { nil }

        let(:id) { 'id' }

        run_test!
      end

      response '404', 'answer not found' do
        schema '$ref' => '#/components/schemas/RecordNotFoundError'

        let(:id) { 'unknown' }

        run_test!
      end
    end

    patch 'Updates an answer' do
      tags 'Answers'

      consumes 'application/json'
      produces 'application/json'

      parameter name: :id, in: :path, type: :string
      parameter name: :answer, in: :body, schema: { '$ref' => '#/components/schemas/Answer' }

      let(:record) { create(:answer) }

      let(:id) { record.id }

      response '200', 'answer updated' do
        let(:answer) do
          { user_id: current_user.sub, alternative_id: create(:alternative).id }
        end

        it 'returns a 200 response' do |example|
          submit_request(example.metadata)

          expect(record.reload).to have_attributes(**answer)

          assert_response_matches_metadata(example.metadata)
        end
      end

      response(401, 'unauthorized') do
        schema '$ref' => '#/components/schemas/UnauthorizedError'

        let(:answer) { {} }

        let(:Authorization) { nil }

        run_test!
      end

      response '422', 'invalid request' do
        schema '$ref' => '#/components/schemas/AnswerError'

        let(:answer) do
          { user_id: nil, alternative_id: nil }
        end

        run_test!
      end
    end

    delete 'Deletes an answer' do
      tags 'Answers'

      consumes 'application/json'

      parameter name: :id, in: :path, type: :string

      response '204', 'answer deleted' do
        let(:id) { create(:answer).id }

        it 'returns a 204 response' do |example|
          expect { submit_request(example.metadata) }.to change { Answer.where(id:).count }.by(-1)

          assert_response_matches_metadata(example.metadata)
        end
      end

      response(401, 'unauthorized') do
        schema '$ref' => '#/components/schemas/UnauthorizedError'

        let(:id) { 'id' }

        let(:answer) { {} }

        let(:Authorization) { nil }

        run_test!
      end

      response '404', 'answer not found' do
        let(:id) { 'unknown' }

        run_test!
      end
    end
  end
end
