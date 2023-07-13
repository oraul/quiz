# frozen_string_literal: true

json.cache! ['v1', @question] do
  json.partial! 'questions/question', question: @question
end
