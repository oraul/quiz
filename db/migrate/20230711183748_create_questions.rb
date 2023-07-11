# frozen_string_literal: true

class CreateQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :questions, id: :uuid do |t|
      t.text :enunciation
      t.belongs_to :topic, null: false, type: :uuid, foreign_key: true

      t.timestamps
    end
  end
end
