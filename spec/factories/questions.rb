# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    sequence(:enunciation) { |i| "Question #{i}" }
    topic

    after(:build) do |question|
      question.alternatives = build_list(:alternative, 4,
                                         question: nil) << build(:alternative, question: nil, correct: true)
    end
  end
end
