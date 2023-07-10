# frozen_string_literal: true

json.extract! discipline, :id, :name, :created_at, :updated_at
json.url discipline_url(discipline, format: :json)
