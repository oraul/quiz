# frozen_string_literal: true

json.cache! ['v1', @topic] do
  json.partial! 'topics/topic', topic: @topic
end
