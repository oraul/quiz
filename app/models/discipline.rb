# frozen_string_literal: true

class Discipline < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
