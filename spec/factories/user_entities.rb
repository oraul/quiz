# frozen_string_literal: true

FactoryBot.define do
  factory :user_entity, class: 'UserEntity' do
    sub { 'dbdc2419-f6cf-49c8-a545-a908a03741ce' }
    name { 'John Doe' }
    exp { 24.hours.from_now.to_i }
    iss { 'auth' }
    aud { 'quiz' }
  end
end
