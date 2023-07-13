# frozen_string_literal: true

json.cache! ['v1', @alternative] do
  json.partial! 'alternatives/alternative', alternative: @alternative
end
