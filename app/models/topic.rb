# frozen_string_literal: true

class Topic < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  has_many :questions, dependent: :delete_all

  belongs_to :discipline
end
