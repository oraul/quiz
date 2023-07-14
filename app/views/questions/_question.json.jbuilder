# frozen_string_literal: true

json.extract! question, :id, :enunciation, :topic_id, :created_at, :updated_at
json.alternatives question.alternatives, partial: 'alternatives/alternative', as: :alternative
json.url question_url(question, format: :json)
