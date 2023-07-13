# frozen_string_literal: true

class Alternative < ApplicationRecord
  validates :description, presence: true
  validates :correct, inclusion: { in: [true, false] }

  belongs_to :question

  has_many :answers, dependent: :delete_all

  def self.cache_by(id)
    new(Rails.cache.fetch("alternative.#{id}", expires_in: 10.minutes) do
      find(id).attributes
    end)
  end
end
