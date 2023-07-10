# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe '/disciplines' do
  path '/disciplines' do
    get 'Retrieves discipline list' do
      tags 'Disciplines'

      produces 'application/json'

      response '200', 'discipline found' do
        schema type: :array,
               items: { '$ref' => '#/components/schemas/Discipline' }

        let(:discipline) { create(:discipline) }

        run_test!
      end
    end

    post 'Creates a discipline' do
      tags 'Disciplines'

      produces 'application/json'
      consumes 'application/json'

      parameter name: :discipline, in: :body, schema: { '$ref' => '#/components/schemas/Discipline' }

      response '201', 'discipline created' do
        let(:discipline) do
          { name: "Discipline #{Time.zone.now}" }
        end

        it 'returns a 201 response' do |example|
          expect { submit_request(example.metadata) }.to change(Discipline, :count).by(1)

          assert_response_matches_metadata(example.metadata)
        end
      end

      response '422', 'invalid request' do
        schema '$ref' => '#/components/schemas/DisciplineError'

        let(:discipline) do
          { name: nil }
        end

        it 'returns a 422 response' do |example|
          expect { submit_request(example.metadata) }.not_to change(Discipline, :count)

          assert_response_matches_metadata(example.metadata)
        end
      end
    end
  end

  path '/disciplines/{id}' do
    get 'Retrieves a discipline' do
      tags 'Disciplines'

      produces 'application/json'

      parameter name: :id, in: :path, type: :string

      response '200', 'discipline found' do
        schema '$ref' => '#/components/schemas/Discipline'

        let(:id) { create(:discipline).id }

        run_test!
      end

      response '404', 'discipline not found' do
        schema '$ref' => '#/components/schemas/RecordNotFoundError'

        let(:id) { 'unknown' }

        run_test!
      end
    end

    patch 'Updates a discipline' do
      tags 'Disciplines'

      consumes 'application/json'
      produces 'application/json'

      parameter name: :id, in: :path, type: :string
      parameter name: :discipline, in: :body, schema: { '$ref' => '#/components/schemas/Discipline' }

      let(:record) { create(:discipline) }

      let(:id) { record.id }

      response '200', 'discipline updated' do
        let(:discipline) do
          { name: "Discipline #{Time.zone.now}" }
        end

        it 'returns a 200 response' do |example|
          submit_request(example.metadata)

          expect(record.reload.name).to eq discipline[:name]

          assert_response_matches_metadata(example.metadata)
        end
      end

      response '422', 'invalid request' do
        schema '$ref' => '#/components/schemas/DisciplineError'

        let(:discipline) do
          { name: nil }
        end

        run_test!
      end
    end

    delete 'Deletes a discipline' do
      tags 'Disciplines'

      consumes 'application/json'

      parameter name: :id, in: :path, type: :string

      response '204', 'discipline deleted' do
        let(:id) { create(:discipline).id }

        it 'returns a 204 response' do |example|
          expect { submit_request(example.metadata) }.to change { Discipline.where(id:).count }.by(-1)

          assert_response_matches_metadata(example.metadata)
        end
      end

      response '404', 'discipline not found' do
        let(:id) { 'unknown' }

        run_test!
      end
    end
  end
end
