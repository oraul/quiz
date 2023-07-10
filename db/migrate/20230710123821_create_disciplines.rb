# frozen_string_literal: true

class CreateDisciplines < ActiveRecord::Migration[7.0]
  def change
    create_table :disciplines, id: :uuid do |t|
      t.string :name

      t.timestamps
    end

    add_index :disciplines, :name, unique: true
  end
end
