# frozen_string_literal: true

class Answer < ApplicationRecord
  validates :user_id, presence: true

  belongs_to :alternative
end
