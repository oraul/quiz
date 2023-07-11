# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    sequence(:enunciation) { |i| "Question #{i}" }
    topic
  end
end
