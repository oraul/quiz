# frozen_string_literal: true

class AddEnunciationIndexToQuestion < ActiveRecord::Migration[7.0]
  def change
    add_index :questions, :enunciation
  end
end
