# frozen_string_literal: true

class Discipline < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  has_many :topics, dependent: :delete_all

  scope :most_answered, lambda { |time = 24.hours.ago|
    select('disciplines.id', 'disciplines.name', 'count(answers.id) as answers_count')
      .joins(topics: [questions: [alternatives: [:answers]]])
      .where('answers.created_at >= ?', time)
      .group('disciplines.id')
      .order('count(answers.id) DESC')
  }
end
