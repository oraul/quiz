# frozen_string_literal: true

class Question < ApplicationRecord
  validates :enunciation, :alternatives, presence: true
  validates :alternatives, length: { is: 5, wrong_length: 'is the wrong length (should be %<count>s objects)' }
  validate :one_alternative_correct?
  validates_associated :alternatives

  belongs_to :topic
  has_many :alternatives, dependent: :delete_all

  accepts_nested_attributes_for :alternatives, allow_destroy: true

  scope :by_topic_id, ->(topic_id) { where(topic_id:) }

  scope :by_enunciation_like, ->(enunciation) { where('enunciation ILIKE ?', "%#{enunciation}%") }

  def one_alternative_correct?
    return false if alternatives.one?(&:correct)

    errors.add(:alternatives, :length, message: 'is the wrong length (should be 1 correct=true)')
  end
end
