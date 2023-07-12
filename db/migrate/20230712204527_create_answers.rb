# frozen_string_literal: true

class CreateAnswers < ActiveRecord::Migration[7.0]
  def change
    create_table :answers, id: :uuid do |t|
      t.uuid :user_id, index: true
      t.belongs_to :alternative, null: false, type: :uuid, foreign_key: true

      t.timestamps
    end
  end
end
