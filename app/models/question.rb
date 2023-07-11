# frozen_string_literal: true

class Question < ApplicationRecord
  validates :enunciation, presence: true

  belongs_to :topic
end
