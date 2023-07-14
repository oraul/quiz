# frozen_string_literal: true

json.cache! ['v1', @discipline] do
  json.partial! 'disciplines/discipline', discipline: @discipline
end
