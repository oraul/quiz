# frozen_string_literal: true

json.extract! alternative, :id, :description, :question_id, :correct, :created_at, :updated_at
json.url alternative_url(alternative, format: :json)
