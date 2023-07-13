# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe '/questions' do
  path '/questions' do
    get 'Retrieves question list' do
      tags 'Questions'

      produces 'application/json'

      parameter name: :by_topic_id, in: :query, type: :string, format: :uuid, required: false
      parameter name: :by_enunciation_like, in: :query, type: :string, required: false

      response '200', 'question found' do
        let(:questions) { create_list(:question, 2, :with_alternatives) }

        schema type: :array,
               items: { '$ref' => '#/components/schemas/Question' }

        before { |example| submit_request(example.metadata) }

        context 'without query params' do
          it 'returns a 200 response' do |example|
            assert_response_matches_metadata(example.metadata)
          end
        end

        context 'with by_topic_id' do
          let(:by_topic_id) { questions.first.topic_id }

          it 'returns a 200 response' do |example|
            expect(response.parsed_body.pluck('id')).to contain_exactly(questions.first.id)
            assert_response_matches_metadata(example.metadata)
          end
        end

        context 'with by_enunciation_like' do
          let(:by_enunciation_like) { questions.first.enunciation }

          it 'returns a 200 response' do |example|
            expect(response.parsed_body.pluck('id')).to contain_exactly(questions.first.id)
            assert_response_matches_metadata(example.metadata)
          end
        end
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
        schema '$ref' => '#/components/schemas/Question'

        let(:question) do
          {
            enunciation: "Question #{Time.zone.now}",
            topic_id: create(:topic).id,
            alternatives_attributes: [
              {
                description: 'Wrong Alternative',
                correct: false
              },
              {
                description: 'Correct Alternative',
                correct: true
              }
            ]
          }
        end

        it 'returns a 201 response' do |example|
          expect do
            submit_request(example.metadata)
          end.to change(Question, :count).by(1).and(change(Alternative, :count).by(2))

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
          { enunciation: nil, topic_id: nil, alternatives_attributes: [{ description: nil, correct: nil }] }
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
        schema '$ref' => '#/components/schemas/Question'

        let(:id) { create(:question, :with_alternatives).id }

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

      let(:record) { create(:question, :with_alternatives) }

      let(:record_child) { record.alternatives.first }

      let(:id) { record.id }

      response '200', 'question updated' do
        schema '$ref' => '#/components/schemas/Question'

        let(:question) do
          {
            enunciation: "Question #{Time.zone.now}",
            alternatives_attributes: [
              { id: record_child.id, description: "Alternative #{Time.zone.now}", correct: false }
            ]
          }
        end

        it 'returns a 200 response' do |example|
          submit_request(example.metadata)

          expect(record.reload).to have_attributes(**question.slice(:enunciation))

          assert_response_matches_metadata(example.metadata)
        end

        it 'updates selected alternative' do |example|
          submit_request(example.metadata)

          expect(record_child.reload).to have_attributes(**question[:alternatives_attributes].first)

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
          { enunciation: nil, topic_id: nil, alternatives_attributes: [{ description: nil, correct: nil }] }
        end

        run_test!
      end
    end

    delete 'Deletes a question' do
      tags 'Questions'

      consumes 'application/json'

      parameter name: :id, in: :path, type: :string

      response '204', 'question deleted' do
        let(:id) { create(:question, :with_alternatives).id }

        it 'returns a 204 response' do |example|
          expect { submit_request(example.metadata) }.to(
            change { Question.where(id:).count }.by(-1).and(change { Alternative.where(question_id: id) }.to([]))
          )

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
