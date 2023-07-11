# frozen_string_literal: true

class Topic < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  belongs_to :discipline
end
