# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    sequence(:enunciation) { |i| "Question #{i}" }
    topic

    trait :with_alternatives do
      after(:create) do |question|
        create(:alternative, question:)
        create(:alternative, correct: true, question:)
      end
    end
  end
end
