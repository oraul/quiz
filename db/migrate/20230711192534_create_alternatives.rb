# frozen_string_literal: true

class CreateAlternatives < ActiveRecord::Migration[7.0]
  def change
    create_table :alternatives, id: :uuid do |t|
      t.string :description, index: true
      t.belongs_to :question, null: false, type: :uuid, foreign_key: true
      t.boolean :correct, null: false, default: false

      t.timestamps
    end
  end
end
