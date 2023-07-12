# frozen_string_literal: true

class Alternative < ApplicationRecord
  validates :description, presence: true
  validates :correct, inclusion: { in: [true, false] }

  belongs_to :question

  has_many :answers, dependent: :delete_all
end
