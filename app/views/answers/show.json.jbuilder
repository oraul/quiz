# frozen_string_literal: true

json.cache! ['v1', @answer] do
  json.partial! 'answers/answer', answer: @answer
end
