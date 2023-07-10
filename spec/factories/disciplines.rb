# frozen_string_literal: true

FactoryBot.define do
  factory :discipline do
    sequence(:name) { |i| "Discipline #{i}" }
  end
end
