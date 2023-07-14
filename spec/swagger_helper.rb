# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.swagger_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under swagger_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'
  config.swagger_docs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'API V1',
        version: 'v1'
      },
      paths: {},
      security: [
        { bearerAuth: [] }
      ],
      servers: [
        {
          url: 'http://{defaultHost}',
          variables: {
            defaultHost: {
              default: 'localhost:3000'
            }
          }
        }
      ],
      components: {
        securitySchemes: {
          bearerAuth: {
            type: 'http',
            scheme: 'bearer',
            bearerFormat: 'JWT'
          }
        },
        schemas: {
          UnauthorizedError: {
            type: 'object',
            properties: {
              message: { type: 'string' }
            },
            required: %w[message]
          },
          RecordNotFoundError: {
            type: 'object',
            properties: {
              message: { type: 'string' }
            },
            required: %w[message]
          },
          Alternative: {
            type: 'object',
            properties: {
              id: { type: 'string', format: 'uuid', readOnly: true },
              description: { type: 'string' },
              correct: { type: 'boolean' },
              question_id: { type: 'string', format: 'uuid' },
              created_at: { type: 'string', format: 'date-time', readOnly: true },
              updated_at: { type: 'string', format: 'date-time', readOnly: true }
            },
            required: %w[id description question_id correct created_at updated_at]
          },
          AlternativeError: {
            type: 'object',
            properties: {
              description: { type: 'array', items: { type: 'string' } },
              correct: { type: 'array', items: { type: 'string' } },
              question: { type: 'array', items: { type: 'string' } }
            }
          },
          Answer: {
            type: 'object',
            properties: {
              id: { type: 'string', format: 'uuid', readOnly: true },
              user_id: { type: 'string', format: 'uuid' },
              alternative_id: { type: 'string', format: 'uuid' },
              created_at: { type: 'string', format: 'date-time', readOnly: true },
              updated_at: { type: 'string', format: 'date-time', readOnly: true },
              url: { type: 'string', format: 'url', readOnly: true }
            },
            required: %w[id user_id alternative_id created_at updated_at url]
          },
          AnswerError: {
            type: 'object',
            properties: {
              user_id: { type: 'array', items: { type: 'string' } },
              alternative_id: { type: 'array', items: { type: 'string' } }
            }
          },
          Discipline: {
            type: 'object',
            properties: {
              id: { type: 'string', format: 'uuid', readOnly: true },
              name: { type: 'string' },
              created_at: { type: 'string', format: 'date-time', readOnly: true },
              updated_at: { type: 'string', format: 'date-time', readOnly: true },
              url: { type: 'string', format: 'url', readOnly: true }
            },
            required: %w[id name created_at updated_at url]
          },
          DisciplineError: {
            type: 'object',
            properties: {
              name: { type: 'array', items: { type: 'string' } }
            }
          },
          'MostAnswered/Discipline': {
            type: 'object',
            properties: {
              id: { type: 'string', format: 'uuid' },
              name: { type: 'string' },
              answers_count: { type: 'integer' }
            }
          },
          Question: {
            type: 'object',
            properties: {
              id: { type: 'string', format: 'uuid', readOnly: true },
              enunciation: { type: 'string' },
              topic_id: { type: 'string', format: 'uuid' },
              alternatives: { type: 'array', items: { '$ref' => '#/components/schemas/Alternative' } },
              created_at: { type: 'string', format: 'date-time', readOnly: true },
              updated_at: { type: 'string', format: 'date-time', readOnly: true },
              url: { type: 'string', format: 'url', readOnly: true }
            },
            required: %w[id enunciation created_at updated_at url]
          },
          QuestionError: {
            type: 'object',
            properties: {
              enunciation: { type: 'array', items: { type: 'string' } },
              topic: { type: 'array', items: { type: 'string' } },
              alternatives: { type: 'array', items: { type: 'string' } },
              'alternatives.description': { type: 'array', items: { type: 'string' } },
              'alternatives.correct': { type: 'array', items: { type: 'string' } }
            }
          },
          Topic: {
            type: 'object',
            properties: {
              id: { type: 'string', format: 'uuid', readOnly: true },
              name: { type: 'string' },
              discipline_id: { type: 'string', format: 'uuid' },
              created_at: { type: 'string', format: 'date-time', readOnly: true },
              updated_at: { type: 'string', format: 'date-time', readOnly: true },
              url: { type: 'string', format: 'url', readOnly: true }
            },
            required: %w[id name created_at updated_at url]
          },
          TopicError: {
            type: 'object',
            properties: {
              name: { type: 'array', items: { type: 'string' } },
              discipline: { type: 'array', items: { type: 'string' } }
            }
          }
        }
      }
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The swagger_docs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.swagger_format = :yaml

  # Strict schema validation
  config.swagger_strict_schema_validation = true
end
