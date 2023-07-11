# frozen_string_literal: true

class Question < ApplicationRecord
  validates :enunciation, presence: true

  belongs_to :topic
  has_many :alternatives, dependent: :delete_all
end
