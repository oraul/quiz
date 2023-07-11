# frozen_string_literal: true

FactoryBot.define do
  factory :alternative do
    sequence(:description) { |i| "Alternative #{i}" }
    question
    correct { false }
  end
end
