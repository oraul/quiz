# frozen_string_literal: true

class CreateTopics < ActiveRecord::Migration[7.0]
  def change
    create_table :topics, id: :uuid do |t|
      t.string :name
      t.belongs_to :discipline, null: false, type: :uuid, foreign_key: true

      t.timestamps
    end

    add_index :topics, :name, unique: true
  end
end
