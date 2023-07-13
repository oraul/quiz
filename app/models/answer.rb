# frozen_string_literal: true

class Answer < ApplicationRecord
  validates :user_id, :alternative_id, presence: true

  belongs_to :alternative, optional: true
end
